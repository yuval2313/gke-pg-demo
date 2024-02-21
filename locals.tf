locals {
  prefixed_name = "${terraform.workspace}-${var.name}"

  vpc_name = "${local.prefixed_name}-vpc"
  router_name = "${local.prefixed_name}-router"
  nat_name = "${local.prefixed_name}-nat"
  
  gke_subnet_name = "${local.prefixed_name}-gke-subnet"
  gke_subnet_pod_range_name = "gke-pod-range"
  gke_subnet_svc_range_name = "gke-svc-range"
  gke_cluster_name = "${local.prefixed_name}-cluster"
  gke_node_group_name = "${local.gke_cluster_name}-ng"

  pg_instance_name = "${local.prefixed_name}-pg-instance"

  api_services = [
    "networkconnectivity.googleapis.com", 
    "compute.googleapis.com", 
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]

  gke_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/autoscaling.metricsWriter",
    "roles/artifactregistry.reader"
  ]
}
