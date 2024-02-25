
g_project = "lyuval-playground"
g_region = "europe-north1"
g_credentials = null

gke_subnet_primary_range = "10.0.0.0/24"
gke_subnet_pod_range = "10.48.0.0/14"
gke_subnet_svc_range = "10.52.0.0/20"
gke_cluster_zones = ["europe-north1-a"]
gke_cluster_master_cidr = "176.16.0.0/28"
gke_enable_private_nodes = true
gke_node_count = 2
gke_node_group_machine_type = "e2-small"
gke_node_group_disk_type = "pd-ssd"
gke_node_group_disk_size = 10

pg_psa_address = "10.240.0.0"
pg_psa_prefix_length = 16
pg_database_version = "POSTGRES_15"
pg_zone = "europe-north1-b"
pg_tier = "db-f1-micro"
pg_disk_type = "PD-SSD"
pg_disk_size = 10
pg_db_name = "mydb"
pg_user_name = "dbuser"
pg_user_password = "dbpass"
pg_root_password = "pgadmin"
pg_ipv4_enabled = true
pg_authorized_networks = [
    {
        name = "any"
        value = "0.0.0.0/0"
    }
]
pg_database_flags = [
    {
        name = "track_activity_query_size"
        value = 4096
    },
    {
        name = "pg_stat_statements.track"
        value = "all"
    },
    {
        name = "pg_stat_statements.max"	
        value = 10000
    },
    {
        name = "pg_stat_statements.track_utility"
        value = "off"
    },
    {
        name = "track_io_timing"
        value = "on"
    },
]

k8s_namespace = "app"