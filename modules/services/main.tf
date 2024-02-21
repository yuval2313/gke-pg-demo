locals {
  api_services = [
    "networkconnectivity.googleapis.com", 
    "compute.googleapis.com", 
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "api_services" {
  count = length(local.api_services)
  disable_on_destroy = false
  service = local.api_services[count.index]
}