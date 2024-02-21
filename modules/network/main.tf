locals {
  vpc_name = "${var.name}-vpc"
  router_name = "${var.name}-router"
  nat_name = "${var.name}-nat"
  gke_subnet_name = "${var.name}-gke-subnet"
}

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
        subnet_name           = local.gke_subnet_name
        subnet_ip             = var.gke_subnet_primary_range
        subnet_region         = var.g_region
        subnet_private_access = "true"
      }
    ]

    secondary_ranges = {
      "${local.gke_subnet_name}" = [
        {
          range_name    = var.gke_subnet_pod_range_name
          ip_cidr_range = var.gke_subnet_pod_range
        },
        {
          range_name    = var.gke_subnet_svc_range_name
          ip_cidr_range = var.gke_subnet_svc_range
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
  depends_on = [module.vpc]
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
      name = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    }
  ]
}