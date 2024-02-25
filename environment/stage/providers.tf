terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.16.0"
    }
  }

  backend "gcs" {
    bucket  = "yuv-tf-backend"
    prefix  = "terraform/gke-pg/stage/state"
  }
}

provider "google" {
  project = var.g_project
  region  = var.g_region
  credentials  = var.g_credentials 
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}