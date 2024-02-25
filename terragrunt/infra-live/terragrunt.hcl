# terraform {
#   extra_arguments "common_vars" {
#     commands = get_terraform_commands_that_need_vars()

#     arguments = [
#       "-var-file=./common.tfvars",
#       "-var-file=./project.tfvars"
#     ]
#   }
# }

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket = "yuv-tf-backend"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "req_providers" {
  path = "req_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.16.0"
    }
    
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}
EOF
}

generate "providers" {
  path = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project = var.g_project
  region  = var.g_region
  credentials  = var.g_credentials 
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://$${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
EOF
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yml")))
}

inputs = {
  g_project = local.common_vars.google_provider.g_project
  g_region = local.common_vars.google_provider.g_region
  g_credentials = local.common_vars.google_provider.g_credentials

  gke_cluster_master_cidr = local.common_vars.gke.gke_cluster_master_cidr
  gke_subnet_primary_range = local.common_vars.gke.gke_subnet_primary_range
  gke_subnet_pod_range = local.common_vars.gke.gke_subnet_pod_range
  gke_subnet_svc_range = local.common_vars.gke.gke_subnet_svc_range
  gke_cluster_zones = local.common_vars.gke.gke_cluster_zones
  gke_node_group_disk_type = local.common_vars.gke.gke_node_group_disk_type

  pg_psa_address = local.common_vars.pg.pg_psa_address
  pg_psa_prefix_length = local.common_vars.pg.pg_psa_prefix_length
  pg_database_version = local.common_vars.pg.pg_database_version
  pg_zone = local.common_vars.pg.pg_zone
  pg_disk_type = local.common_vars.pg.pg_disk_type
  pg_db_name = local.common_vars.pg.pg_db_name
  pg_user_name = local.common_vars.pg.pg_user_name
  pg_user_password = local.common_vars.pg.pg_user_password
  pg_root_password = local.common_vars.pg.pg_root_password
  pg_database_flags = local.common_vars.pg.pg_database_flags

  k8s_namespace   = local.common_vars.k8s.k8s_namespace
}

