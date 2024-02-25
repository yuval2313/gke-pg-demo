output "network_name" {
    value = module.vpc.network_name
}
output "network_self_link" {
    value = module.vpc.network_self_link
}
output "network_id" {
    value = module.vpc.network_id
}

output "subnet_name" {
    value = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].name
}
output "subnet_self_link" {
    value = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].self_link
}
output "subnet_id" {
    value = module.vpc.subnets["${var.g_region}/${local.gke_subnet_name}"].id
}

output gke_subnet_pod_range_name {
    value = local.gke_subnet_pod_range_name
}
output gke_subnet_svc_range_name {
    value = local.gke_subnet_svc_range_name
} 

output "peering_completed" {
  value       = null_resource.dependency_setter.id
  description = "Indicates VPC peering is completed, useful for enforcing ordering between resource creation."
}