locals {
  name = "${terraform.workspace}-${var.environment}"

  vpc_name = "${local.name}-vpc"
  router_name = "${local.name}-router"
  nat_name = "${local.name}-nat"
  
  gke_subnet_name = "${local.name}-gke-subnet"
  gke_subnet_pod_range_name = "gke-pod-range"
  gke_subnet_svc_range_name = "gke-svc-range"
  gke_cluster_name = "${local.name}-cluster"
  gke_node_group_name = "${local.gke_cluster_name}-ng"

  pg_instance_name = "${local.name}-pg-instance"

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

  network_tier = var.environment == "dev" ? var.network_tier : "PREMIUM"
  gke_deletion_protection = var.environment == "dev" ? var.gke_deletion_protection : true
  gke_enable_private_nodes = var.environment == "dev" ? var.gke_enable_private_nodes : true
  gke_enable_logging_service = var.environment == "dev" ? var.gke_enable_logging_service : true
  gke_enable_monitoring_service = var.environment == "dev" ? var.gke_enable_monitoring_service : true
  gke_enable_managed_prometheus = var.environment == "dev" ? var.gke_enable_managed_prometheus : true
  pg_database_version = var.environment == "dev" ? var.pg_database_version : "POSTGRES_15"
  pg_is_zonal = var.environment == "dev" ? var.pg_is_zonal : false
  pg_deletion_protection_enabled = var.environment == "dev" ? var.pg_deletion_protection_enabled : true
}
