resource "google_service_account" "gke_sa" {
  account_id   = local.gke_sa_name
  display_name = "GKE Service Account for ${local.gke_cluster_name}"
}

resource "google_project_iam_binding" "role_bindings" {
  count = length(local.gke_sa_roles)
  project = var.g_project
  role    = local.gke_sa_roles[count.index]

  members = [
    "serviceAccount:${google_service_account.gke_sa.email}"
  ]
}