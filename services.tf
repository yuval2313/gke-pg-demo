resource "google_project_service" "api_services" {
  count = length(local.api_services)
  disable_on_destroy = false
  service = local.api_services[count.index]
}