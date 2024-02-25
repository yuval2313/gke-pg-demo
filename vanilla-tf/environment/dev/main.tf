module services {
    source = "../../modules/services"
}

module vpc {
    source = "../../modules/vpc"
    
    name = local.name
    g_project = var.g_project
    g_region = var.g_region
    
    network_tier = "STANDARD"
    gke_subnet_primary_range = var.gke_subnet_primary_range
    gke_subnet_pod_range = var.gke_subnet_pod_range
    gke_subnet_svc_range = var.gke_subnet_svc_range
    pg_psa_address = var.pg_psa_address
    pg_psa_prefix_length = var.pg_psa_prefix_length
}

module gke {
    source = "../../modules/gke"
    depends_on = [module.vpc, module.services]

    name = local.name
    g_project = var.g_project
    g_region = var.g_region
    
    gke_network = module.vpc.network_name
    gke_subnet = module.vpc.subnet_name
    gke_subnet_pod_range_name = module.vpc.gke_subnet_pod_range_name
    gke_subnet_svc_range_name = module.vpc.gke_subnet_svc_range_name
    gke_deletion_protection = false
    gke_is_regional_cluster = false
    gke_cluster_zones = var.gke_cluster_zones
    gke_cluster_master_cidr = var.gke_cluster_master_cidr
    gke_enable_private_nodes = var.gke_enable_private_nodes
    gke_enable_logging_service = false
    gke_enable_monitoring_service = false
    gke_enable_managed_prometheus = false
    gke_node_count = var.gke_node_count
    gke_node_group_machine_type = var.gke_node_group_machine_type
    gke_node_group_disk_type = var.gke_node_group_disk_type
    gke_node_group_disk_size = var.gke_node_group_disk_size
}

module pg {
    source = "../../modules/pg"
    depends_on = [module.vpc.peering_completed, module.services]

    name = local.name
    g_project = var.g_project
    g_region = var.g_region
    
    network_id = module.vpc.network_id
    pg_database_version = var.pg_database_version
    pg_is_enterprise_plus = false
    pg_is_zonal = true
    pg_zone = var.pg_zone
    pg_secondary_zone = null
    pg_tier = var.pg_tier
    pg_disk_type = var.pg_disk_type
    pg_disk_size = var.pg_disk_size
    pg_deletion_protection_enabled = false
    pg_db_name = var.pg_db_name
    pg_user_name = var.pg_user_name
    pg_user_password = var.pg_user_password
    pg_root_password = var.pg_root_password
    pg_ipv4_enabled = var.pg_ipv4_enabled
    pg_authorized_networks = var.pg_authorized_networks
    pg_database_flags = var.pg_database_flags
}

module k8s {
    source = "../../modules/k8s"
    depends_on = [module.gke, module.pg]

    k8s_namespace = var.k8s_namespace
    pg_private_ip_address = module.pg.private_ip_address
    pg_db_name = module.pg.db_name
    pg_user_name = module.pg.user_name
    pg_user_password = module.pg.user_password
}
