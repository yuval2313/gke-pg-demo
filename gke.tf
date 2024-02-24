resource "google_service_account" "gke_sa" {
  account_id   = "${local.name}-gke-sa"
  display_name = "GKE Service Account for ${local.name} terraform project"
}

resource "google_project_iam_binding" "role_bindings" {
  count = length(local.gke_sa_roles)
  project = var.g_project
  role    = local.gke_sa_roles[count.index]

  members = [
    "serviceAccount:${google_service_account.gke_sa.email}"
  ]
}

module "gke" {
  depends_on = [module.vpc, google_project_service.api_services]
  source              = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id          = var.g_project
  name                = local.gke_cluster_name
  description         = "Cluster provisioned as part of ${local.name} Terraform project."
  deletion_protection = local.gke_deletion_protection

  region   = var.g_region
  regional = var.gke_is_regional_cluster
  zones    = var.gke_cluster_zones
  
  master_ipv4_cidr_block  = var.gke_cluster_master_cidr  
  enable_private_nodes    = local.gke_enable_private_nodes
  enable_private_endpoint = false
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].name
  ip_range_pods           = local.gke_subnet_pod_range_name
  ip_range_services       = local.gke_subnet_svc_range_name
  
  create_service_account = false
  service_account        = google_service_account.gke_sa.email

  logging_service                      = local.gke_enable_logging_service ? "logging.googleapis.com/kubernetes" : "none"
  monitoring_service                   = local.gke_enable_monitoring_service ? "monitoring.googleapis.com/kubernetes" : "none"
  monitoring_enable_managed_prometheus = local.gke_enable_managed_prometheus


  remove_default_node_pool = true
  node_pools = [
    {
      name               = local.gke_node_group_name
      machine_type       = var.gke_node_group_machine_type
      autoscaling        = false
      node_count         = var.gke_node_count
      disk_type          = var.gke_node_group_disk_type
      disk_size_gb       = var.gke_node_group_disk_size
      auto_repair        = true
      auto_upgrade       = true
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}