variable "g_project" {
  type        = string
  description = "GCP project."
}
variable "g_region" { 
  type        = string
  description = "GCP region."
}

variable "name" {
  type        = string
  description = "Name to be used as part of created resources' names."
}

variable network_tier {
  type        = string
  description = "GCP network service tier (PREMIUM | STANDARD)."
}

variable gke_subnet_primary_range {
  type = string
  description = "Primary IP Range for cluster subnet."  
}
variable gke_subnet_pod_range {
  type = string
  description = "Secondary IP Range for cluster pods."  
}
variable gke_subnet_svc_range {
  type = string
  description = "Secondary IP Range for cluster services."  
}
variable gke_subnet_pod_range_name {
  type = string
  description = "Name of secondary IP Range for cluster pods."  
}
variable gke_subnet_svc_range_name {
  type = string
  description = "Name of secondary IP Range for cluster services."  
}