resource "google_compute_global_address" "google-managed-services-range" {
  name          = "google-managed-services-${module.vpc.network_name}"
  project       = var.g_project
  description   = "Peering connection between ${module.vpc.network_name} VPC and Google managed services' VPC."
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

resource "null_resource" "dependency_setter" {
  depends_on = [google_service_networking_connection.private_service_access]
}