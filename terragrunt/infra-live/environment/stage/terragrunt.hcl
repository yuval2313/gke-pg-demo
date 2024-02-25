terraform {
  source = "github.com/yuval2313/gke-pg-demo.git//terragrunt/infra-modules?ref=main"
}

inputs = {
  environment = "stage"
  network_tier = "STANDARD"

  gke_deletion_protection = false
  gke_is_regional_cluster = false
  gke_enable_logging_service = true
  gke_enable_monitoring_service = true
  gke_enable_managed_prometheus = true
  gke_enable_private_nodes = true
  gke_node_count = 2
  gke_node_group_machine_type = "e2-medium"
  gke_node_group_disk_size = 40

  pg_is_zonal = false
  pg_deletion_protection_enabled = false
  pg_tier = "db-g1-small"
  pg_disk_size = 50
  pg_ipv4_enabled = true
  pg_authorized_networks = [
      {
          name = "any"
          value = "0.0.0.0/0"
      }
  ]
}

include "root" {
  path = find_in_parent_folders()
}