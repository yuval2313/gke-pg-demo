module "pg_instance" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "18.2.0"

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

  user_deletion_policy = "ABANDON"
  database_deletion_policy = "ABANDON"
  db_name = var.pg_db_name
  user_name = var.pg_user_name
  user_password = var.pg_user_password
  root_password = var.pg_root_password

  ip_configuration = {
    ipv4_enabled = var.pg_ipv4_enabled 
    authorized_networks = var.pg_authorized_networks 
    private_network = var.network_id
    enable_private_path_for_google_cloud_services = true
  }

  database_flags = var.pg_database_flags
}
