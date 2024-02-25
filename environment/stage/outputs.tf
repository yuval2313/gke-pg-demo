output k_config_cmd {
  value = "gcloud container clusters get-credentials ${module.gke.name} --region=${module.gke.location}"
}