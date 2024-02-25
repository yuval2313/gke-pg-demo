module "cloud_nat" {
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