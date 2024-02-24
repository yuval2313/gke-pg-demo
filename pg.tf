resource "google_compute_global_address" "google-managed-services-range" {
  name          = "google-managed-services-${module.vpc.network_name}"
  project       = var.g_project
  description   = "Peering connection between ${module.vpc.network_name} VPC and ${local.pg_instance_name} SQL instance's Google managed VPC."
  purpose       = "VPC_PEERING"
  address       = var.pg_psa_address
  prefix_length = var.pg_psa_prefix_length
  ip_version    = "IPV4"
  address_type  = "INTERNAL"
  network       = module.vpc.network_self_link
}

resource "google_service_networking_connection" "private_service_access" {
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google-managed-services-range.name]
  deletion_policy = "ABANDON"
}

# PG Instance
module "pg-instance" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "18.2.0"
  depends_on = [google_service_networking_connection.private_service_access]

  name = local.pg_instance_name
  project_id = var.g_project
  region = var.g_region
  database_version = local.pg_database_version

  edition = var.pg_is_enterprise_plus ? "ENTERPRISE_PLUS" : "ENTERPRISE"
  availability_type = local.pg_is_zonal ? "ZONAL" : "REGIONAL"
  zone = var.pg_zone
  secondary_zone = var.pg_secondary_zone
  tier = var.pg_tier
  disk_type = var.pg_disk_type
  disk_size = var.pg_disk_size

  deletion_protection = local.pg_deletion_protection_enabled
  deletion_protection_enabled = local.pg_deletion_protection_enabled

  user_deletion_policy = "ABANDON"
  database_deletion_policy = "ABANDON"
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

  database_flags = var.pg_database_flags
}
