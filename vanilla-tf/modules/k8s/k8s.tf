resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.k8s_namespace
  }
}

resource "kubernetes_secret" "db-cred" {
  depends_on = [kubernetes_namespace.namespace]
  
  metadata {
    name = "db-cred"
    namespace = var.k8s_namespace
  }

  data = {
    DB_HOST = var.pg_private_ip_address
    DB_NAME = var.pg_db_name
    DB_USER = var.pg_user_name
    DB_PASSWORD  = var.pg_user_password
  }
}