resource "google_compute_project_default_network_tier" "default" {
  network_tier = var.network_tier
}