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

variable gke_network {
  type = string
  description = "VPC Network meant for cluster, name / self_link."
}
variable gke_subnet {
  type = string
  description = "Subnet meant for cluster, name / self_link."
}
variable gke_subnet_pod_range_name {
  type = string
  description = "Secondary subnet range name meant for pods (should already exist beforehand in gke_subnet)."
}
variable gke_subnet_svc_range_name {
  type = string
  description = "Secondary subnet range name meant for services (should already exist beforehand in gke_subnet)."
}

variable gke_deletion_protection {
  type = bool
  description = "Enable deletion protection on GKE cluster."
}

variable gke_is_regional_cluster {
  type        = bool
  description = "Whether to create a regional cluster."
}
variable gke_cluster_zones {
  type        = list(string)
  description = "Zones for zonal cluster, ignored for regional clusters."
}
variable gke_cluster_master_cidr {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network."
}

variable gke_enable_private_nodes {
  type = bool
  description = "Whether to provision nodes with only private ips"
}

variable gke_enable_logging_service {
  type        = bool
  description = "Whether to enable managed logging service."
}
variable gke_enable_monitoring_service {
  type        = bool
  description = "Whether to enable managed monitoring service."
}
variable gke_enable_managed_prometheus {
  type        = bool
  description = "Whether to enable managed prometheus service."
}

variable gke_node_count {
  type        = number
  description = "Number of nodes in cluster node group."
}
variable gke_node_group_machine_type {
  type        = string
  description = "Machine type for node group."
}
variable gke_node_group_disk_type {
  type = string
  description = "Persistent disk type attached to each node in node group."
}
variable gke_node_group_disk_size {
  type = number
  description = "Persistent disk size attached to each node in node group."
}