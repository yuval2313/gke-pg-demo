locals {
    gke_cluster_name = "${var.name}-cluster"
    gke_node_group_name = "${local.gke_cluster_name}-ng"
    gke_sa_name = "${terraform.workspace}gkesa"

    gke_sa_roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/monitoring.viewer",
        "roles/stackdriver.resourceMetadata.writer",
        "roles/autoscaling.metricsWriter",
        "roles/artifactregistry.reader"
    ]
}