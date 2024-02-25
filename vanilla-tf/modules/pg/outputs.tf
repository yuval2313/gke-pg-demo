output "private_ip_address" {
  value = module.pg_instance.private_ip_address
}

output "public_ip_address" {
  value = module.pg_instance.public_ip_address
}

output "db_name" {
  value = var.pg_db_name == "" ? "default" : var.pg_db_name
}

output "user_name" {
  value = var.pg_user_name == "" ? "default" : var.pg_user_name
}

output "user_password" {
  value = var.pg_user_password == "" ? module.pg_instance.generated_user_password : var.pg_user_password
}