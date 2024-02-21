resource "kubernetes_namespace" "namespace" {
  depends_on = [module.gke]

  metadata {
    name = var.k8s_namespace
  }
}

resource "kubernetes_secret" "db-cred" {
  depends_on = [module.gke, module.pg-instance, kubernetes_namespace.namespace]
  
  metadata {
    name = "db-cred"
    namespace = var.k8s_namespace
  }

  data = {
    DB_HOST = module.pg-instance.private_ip_address
    DB_NAME = var.pg_db_name == "" ? "default" : var.pg_db_name
    DB_USER = var.pg_user_name == "" ? "default" : var.pg_user_name
    DB_PASSWORD  = var.pg_user_password == "" ? module.pg-instance.generated_user_password : var.pg_user_password
  }
}