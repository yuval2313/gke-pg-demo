terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.16.0"
    }
  }

  backend "gcs" {
    bucket  = "yuv-tf-backend"
    prefix  = "terraform/gke-pg/state"
  }
}

provider "google" {
  project = var.g_project
  region  = var.g_region
  credentials  = var.g_credentials 
}