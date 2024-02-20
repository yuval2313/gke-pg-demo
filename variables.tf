# providers.tf
variable "g_project" {
  type        = string
  description = "GCP project"
}
variable "g_region" { 
  type        = string
  description = "GCP region"
}
variable "g_credentials" {
  type        = string
  default     = null
  description = "GCP credentials path"
}

# main.tf
variable "name" {
  type        = string
  default     = "pg-demo"
  description = "Name to be used as part of created resources' names"
}
