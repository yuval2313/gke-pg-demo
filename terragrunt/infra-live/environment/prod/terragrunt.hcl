terraform {
  source = "github.com/yuval2313/gke-pg-demo.git//terragrunt/infra-modules?ref=main"
}

inputs = {
  environment = "prod"
  network_tier = "PREMIUM"

  gke_deletion_protection = true
  gke_is_regional_cluster = true
  gke_enable_logging_service = true
  gke_enable_monitoring_service = true
  gke_enable_managed_prometheus = true
  gke_enable_private_nodes = true
  gke_node_count = 3
  gke_node_group_machine_type = "e2-medium"
  gke_node_group_disk_size = 50

  pg_is_zonal = false
  pg_deletion_protection_enabled = true
  pg_tier = "db-n1-standard-1"
  pg_disk_size = 100
  pg_ipv4_enabled = false
  pg_authorized_networks = []
}

include "root" {
  path = find_in_parent_folders()
}