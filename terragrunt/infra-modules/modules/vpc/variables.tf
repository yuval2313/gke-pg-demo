variable "name" {
  type        = string
  description = "Name to be used when creating resources."
}

variable g_project {
  type        = string
  description = "GCP project."
}
variable g_region { 
  type        = string
  description = "GCP region."
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

variable pg_psa_address {
  type = string
  description = "First IP address of the IP range to allocate to Private Service Access services. If not set, GCP will pick a valid one for you."
}
variable pg_psa_prefix_length {
  type = number
  default = 16
  description = "Prefix length of the IP range reserved for Private Service Access services. Defaults to /16."
}




