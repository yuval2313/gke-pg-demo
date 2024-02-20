locals {
    prefixed_name = "${terraform.workspace}-${var.name}"

    vpc_name = "${local.prefixed_name}-vpc"
    router_name = "${local.prefixed_name}-router"
    nat_name = "${local.prefixed_name}-nat"
    k8s_subnet_name = "${local.prefixed_name}-k8s-subnet"

    k8s_subnet_pod_range_name = "k8s-pod-range"
    k8s_subnet_svc_range_name = "k8s-svc-range"

    api_services = [
      "networkconnectivity.googleapis.com", 
      "compute.googleapis.com", 
      "container.googleapis.com",
      "servicenetworking.googleapis.com",
      "sqladmin.googleapis.com",
      "cloudresourcemanager.googleapis.com"
    ]
}

resource "google_project_service" "api_service" {
  count = length(local.api_services)
  disable_on_destroy = false
  service = local.api_services[count.index]
}

# network service tier
resource "google_compute_project_default_network_tier" "default" {
  network_tier = var.network_tier
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 9.0"

    project_id   = var.g_project
    network_name = local.vpc_name
    delete_default_internet_gateway_routes = true

    subnets = [
      {
        subnet_name           = local.k8s_subnet_name
        subnet_ip             = var.k8s_subnet_primary_range
        subnet_region         = var.g_region
        subnet_private_access = var. is_private_cluster ? "true" : "false"
      }
    ]

    secondary_ranges = {
      "${local.k8s_subnet_name}" = [
        {
          range_name    = local.k8s_subnet_pod_range_name
          ip_cidr_range = var.k8s_subnet_pod_range
        },
        {
          range_name    = local.k8s_subnet_svc_range_name
          ip_cidr_range = var.k8s_subnet_svc_range
        }
      ]
    }

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            next_hop_internet      = "true"
        }
    ]
}

module "cloud-nat" {
  count = var.is_private_cluster ? 1 : 0

  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  project_id = var.g_project
  region     = var.g_region
  
  network = module.vpc.network_name
  create_router = true
  router = local.router_name
  name = local.nat_name

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetworks = [
    {
      name = local.k8s_subnet_name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    }
  ]
}

resource "google_compute_address" "psc-address" {
  name         = "${local.prefixed_name}-psc-address"
  region       = var.g_region
  address_type = "INTERNAL"
  subnetwork   = local.k8s_subnet_name     # Replace value with the name of the subnet here.
  address      = cidrhost(var.k8s_subnet_primary_range, -3)
}

module "pg-instance" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "18.2.0"

  name = "${local.prefixed_name}-pg-instance"
  project_id = var.g_project
  database_version = var.pg_database_version

  edition = var.is_enterprise_plus_pg ? "ENTERPRISE_PLUS" : "ENTERPRISE"
  availability_type = is_zonal_pg ? "ZONAL" : "REGIONAL"
  zone = var.pg_zone
  secondary_zone = var.pg_secondary_zone
  tier = var.pg_tier
  disk_type = var.pg_disk_type
  disk_size = var.pg_disk_size
  deletion_protection_enabled = var.pg_deletion_protection_enabled

  db_name = var.pg_db_name
  user_name = var.pg_user_name
  user_password = var.pg_user_password
  root_password = var.pg_root_password

  ip_configuration =  {
    ipv4_enabled = var.pg_ipv4_enabled 
    authorized_networks = var.pg_authorized_networks 
    private_network = module.vpc.network_self_link
    enable_private_path_for_google_cloud_services = var.enable_private_path_for_google_cloud_services
    psc_enabled = true
    psc_allowed_consumer_projects = [var.g_project]
  }
}

resource "google_compute_forwarding_rule" "pg-instance" {
  name                  = "${module.pg-instance.instance_name}-psc-forwarding-rule"
  region                = var.g_region
  network               = module.vpc.network_self_link
  ip_address            = google_compute_address.psc-address.self_link
  load_balancing_scheme = ""
  target                = module.pg-instance.instance_psc_attachment
}

