locals {
  module_name = basename(abspath(path.module))
  name = "${terraform.workspace}-${local.module_name}"
}