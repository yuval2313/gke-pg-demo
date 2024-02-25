# environment
variable environment {
  type = string
  default = "dev"
  validation {
    condition = var.environment == "dev" || var.environment == "stage" || var.environment == "prod"
    error_message = "Accepted values are 'dev' / 'stage' / 'prod'."
  }
}

# providers
variable g_project {
  type        = string
  description = "GCP project."
}
variable g_region { 
  type        = string
  description = "GCP region."
}
variable g_credentials {
  type        = string
  default     = null
  description = "GCP credentials path."
}

# network
variable network_tier {
  type = string
  default = "STANDARD"
  description = "Network pricing tier, possible values are 'STANDARD' or 'PREMIUM'."
}

variable gke_subnet_primary_range {
  type = string
  default = "10.0.0.0/24"
  description = "Primary IP Range for cluster subnet."  
}
variable gke_subnet_pod_range {
  type = string
  default = "10.48.0.0/14"
  description = "Secondary IP Range for cluster pods."  
}
variable gke_subnet_svc_range {
  type = string
  default = "10.52.0.0/20"
  description = "Secondary IP Range for cluster services."  
}

variable pg_psa_address {
  type = string
  default = ""
  description = "First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you."
}
variable pg_psa_prefix_length {
  type = number
  default = 16
  description = "Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16."
}


# gke
variable gke_deletion_protection {
  type = bool
  default = true
  description = "Whether to enable deletion protection on the GKE cluster."
}
variable gke_is_regional_cluster {
  type = bool
  default = false
  description = "Whether to create a regional GKE cluster."
}
variable gke_cluster_zones {
  type        = list(string)
  description = "Zones for zonal cluster, ignored for regional clusters."
}
variable gke_cluster_master_cidr {
  type        = string
  default     = "176.16.0.0/28"
  description = "The IP range in CIDR notation to use for the hosted master network."
}

variable gke_enable_logging_service {
  type = bool
  default = false
  description = "Whether to enable logging service for the GKE cluster."
}
variable gke_enable_monitoring_service {
  type = bool
  default = false
  description = "Whether to enable monitoring service for the GKE cluster."
}
variable gke_enable_managed_prometheus {
  type = bool
  default = false
  description = "Whether to enable managed prometheus for the GKE cluster."
}

variable gke_enable_private_nodes {
  type = bool
  default = true
  description = "Whether to provision nodes with only private ips"
}

variable gke_node_count {
  type        = number
  default     = 1
  description = "Number of nodes in cluster node group."
}
variable gke_node_group_machine_type {
  type        = string
  default     = "e2-small"
  description = "Machine type for node group."
}
variable gke_node_group_disk_type {
  type = string
  default = "pd-ssd"
  description = "Persistent disk type attached to each node in node group."
}
variable gke_node_group_disk_size {
  type = number
  default = 30
  description = "Persistent disk size attached to each node in node group."
}

# pg
variable pg_is_zonal {
  type = bool
  default = true
  description = "Whether to create a highly available Postgres instance."
}
variable pg_secondary_zone {
  type = string
  default = null
  description = "Explicitly set the secondary zone for a highly available Postgres instance."
}
variable pg_deletion_protection_enabled {
  type = bool
  default = true
  description = "Whether to enable deletion protection on the Postgres instance."
}

variable pg_database_version {
  type = string
  default = "POSTGRES_15"
  description = "The database version to use."
}
variable pg_zone {
  type = string
  default = null
  description = "Explicitly set the zone of the master instance."
}
variable pg_tier {
  type = string
  default = "db-f1-micro"
  description = "The tier for the master instance - https://cloud.google.com/sdk/gcloud/reference/sql/tiers/list."
}
variable pg_disk_type {
  type = string
  default = "PD_SSD"
  description = "The disk type for the master instance."
}
variable pg_disk_size {
  type = number
  default = 10
  description = "The disk size for the master instance."
}

variable pg_db_name {
  type = string
  default = "default"
  description = "Default database name."
}
variable pg_user_name {
  type = string
  default = "default"
  description = "Default user name"
}
variable pg_user_password {
  type = string
  default = ""
  sensitive = true
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}
variable pg_root_password {
  type = string
  default = null
  sensitive = true
  description = "Initial root password during creation."
}
variable pg_ipv4_enabled {
  type = bool
  default = true
  description = "Whether this Cloud SQL instance should be assigned a public IPV4 address."
}
variable pg_authorized_networks {
  type = list(object({
    name = string
    value = string
  }))
  default = []
  description = "List of authorized networks when enabling ipv4. Each object must contain a name and a value for the authorized ip_range."
}
variable pg_database_flags {
  type = list(object({
    name = string
    value = any
  }))
  default = []
  description = "The database flags for the master instance. See https://cloud.google.com/sql/docs/postgres/flags"
}

# k8s
variable k8s_namespace {
  type = string
  default = "app"
  description = "Namespace to create in cluster, in which database credentials are stored"
}