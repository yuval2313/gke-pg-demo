variable "k8s_namespace" {
  type = string
  description = "Namespace to create in cluster, in which database credentials are stored"
}

variable pg_private_ip_address {
  type = string
  description = "Postgres Instance private IP address."
}
variable pg_db_name {
  type = string
  description = "Postgres Instance database name."
}
variable pg_user_name {
  type = string
  description = "Postgres Instance user name."
}
variable pg_user_password {
  type = string
  sensitive = true
  description = "Postgres Instance user password."
}