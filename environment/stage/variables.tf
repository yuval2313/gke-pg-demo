# providers.tf
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
# network.tf

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

# gke.tf
variable gke_cluster_master_cidr {
  type        = string
  default     = "176.16.0.0/28"
  description = "The IP range in CIDR notation to use for the hosted master network."
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

# pg.tf
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

variable pg_zone {
  type = string
  default = null
  description = "Explicitly set the zone of the master instance."
}
variable pg_secondary_zone {
  type = string
  default = null
  description = "Explicitly set the zone for the secondary/failover instance (only for non-zonal)."
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

# k8s.tf
variable "k8s_namespace" {
  type = string
  default = "app"
  description = "Namespace to create in cluster, in which database credentials are stored"
}