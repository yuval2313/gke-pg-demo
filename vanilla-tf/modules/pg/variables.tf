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

variable network_id {
  type = string
  description = "VPC Network ID meant for instance."
}

variable pg_database_version {
  type = string
  description = "The database version to use."
}
variable pg_is_enterprise_plus {
  type = bool
  description = "Whether to use ENTERPRISE_PLUS (true) edition or just ENTERPRISE (false)."
}
variable pg_is_zonal {
  type = bool
  description = "The availability type for the master instance - ZONAL (true) or REGIONAL (false)."
}
variable pg_zone {
  type = string
  description = "Explicitly set the zone of the master instance."
}
variable pg_secondary_zone {
  type = string
  description = "Explicitly set the zone for the secondary/failover instance (only for non-zonal)."
}
variable pg_tier {
  type = string
  description = "The tier for the master instance - https://cloud.google.com/sdk/gcloud/reference/sql/tiers/list."
}
variable pg_disk_type {
  type = string
  description = "The disk type for the master instance."
}
variable pg_disk_size {
  type = number
  description = "The disk size for the master instance."
}
variable pg_deletion_protection_enabled {
  type = bool
  description = "Whether to enable deletion protection for instance accross all surfaces."
}

variable pg_db_name {
  type = string
  description = "Default database name."
}
variable pg_user_name {
  type = string
  description = "Default user name"
}
variable pg_user_password {
  type = string
  sensitive = true
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}
variable pg_root_password {
  type = string
  sensitive = true
  description = "Initial root password during creation."
}
variable pg_ipv4_enabled {
  type = bool
  description = "Whether this Cloud SQL instance should be assigned a public IPV4 address."
}
variable pg_authorized_networks {
  type = list(object({
    name = string
    value = string
  }))
  description = "List of authorized networks when enabling ipv4. Each object must contain a name and a value for the authorized ip_range."
}
variable pg_database_flags {
  type = list(object({
    name = string
    value = any
  }))
  description = "The database flags for the master instance. See https://cloud.google.com/sql/docs/postgres/flags"
}