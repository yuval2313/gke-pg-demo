locals {
    prefixed_name = "${terraform.workspace}-${var.name}"
    
    gke_subnet_pod_range_name = "gke-pod-range"
    gke_subnet_svc_range_name = "gke-svc-range"

    gke_cluster_name = "${local.prefixed_name}-gke-cluster"
    gke_node_group_name = "${local.gke_cluster_name}-node-group"
    gke_sa_name = "${local.gke_cluster_name}-sa"

    pg_instance_name = "${local.prefixed_name}-pg-instance"
}

module "name" {
  source = "./modules/services"
}

module "network" {
  source = "./modules/network"

  name = local.prefixed_name
  g_project = var.g_project
  g_region = var.g_region
  network_tier = var.network_tier
  gke_subnet_primary_range = var.gke_subnet_primary_range
  gke_subnet_pod_range = var.gke_subnet_pod_range
  gke_subnet_svc_range = var.gke_subnet_svc_range
  
  gke_subnet_pod_range_name = local.gke_subnet_pod_range_name
  gke_subnet_svc_range_name = local.gke_subnet_svc_range_name
  
}

# gke
module "gke" {
  depends_on = [module.vpc, google_project_service.api_services]
  source              = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id          = var.g_project
  name                = local.gke_cluster_name
  description         = var.gke_cluster_description
  deletion_protection = var.gke_deletion_protection

  region   = var.g_region
  regional = var.gke_is_regional_cluster
  zones    = var.gke_cluster_zones
  
  master_ipv4_cidr_block  = var.gke_cluster_master_cidr  
  enable_private_nodes    = var.gke_enable_private_nodes
  enable_private_endpoint = false
  network                 = module.vpc.network_self_link
  subnetwork              = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].name
  ip_range_pods           = local.gke_subnet_pod_range_name
  ip_range_services       = local.gke_subnet_svc_range_name
  
  service_account_name  = local.gke_sa_name 
  grant_registry_access = true

  logging_service                      = var.gke_enable_logging_service ? "logging.googleapis.com/kubernetes" : "none"
  monitoring_service                   = var.gke_enable_monitoring_service ? "monitoring.googleapis.com/kubernetes" : "none"
  monitoring_enable_managed_prometheus = var.gke_enable_managed_prometheus


  remove_default_node_pool = true
  node_pools = [
    {
      name               = local.gke_node_group_name
      machine_type       = var.gke_node_group_machine_type
      initial_node_count = var.gke_node_count
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

module "pg-private-service-access" {
    source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
    version = "18.2.0"
    depends_on = [module.vpc]

    project_id = var.g_project
    vpc_network = module.vpc.network_name

    address = var.pg_psa_address
    prefix_length = var.pg_psa_prefix_length
    description = "Peering connection between ${module.vpc.network_name} VPC and ${local.pg_instance_name} SQL instance's Google managed VPC."
    ip_version = "IPV4"
}

# PG Instance
module "pg-instance" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "18.2.0"
  depends_on = [module.pg-private-service-access.peering_completed, google_project_service.api_services]

  name = local.pg_instance_name
  project_id = var.g_project
  region = var.g_region
  database_version = var.pg_database_version

  edition = var.pg_is_enterprise_plus ? "ENTERPRISE_PLUS" : "ENTERPRISE"
  availability_type = var.pg_is_zonal ? "ZONAL" : "REGIONAL"
  zone = var.pg_zone
  secondary_zone = var.pg_secondary_zone
  tier = var.pg_tier
  disk_type = var.pg_disk_type
  disk_size = var.pg_disk_size

  deletion_protection = var.pg_deletion_protection_enabled
  deletion_protection_enabled = var.pg_deletion_protection_enabled

  enable_default_db = var.pg_enable_default_db
  enable_default_user = var.pg_enable_default_user

  db_name = var.pg_db_name
  user_name = var.pg_user_name
  user_password = var.pg_user_password
  root_password = var.pg_root_password


  ip_configuration = {
    ipv4_enabled = var.pg_ipv4_enabled 
    authorized_networks = var.pg_authorized_networks 
    private_network = module.vpc.network_id
    enable_private_path_for_google_cloud_services = true
  }
}

