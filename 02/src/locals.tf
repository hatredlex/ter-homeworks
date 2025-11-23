locals {
  vm_web_name = "${var.prefix}-${var.vpc_name}-${var.vm_web_resource_name}"
  vm_db_name  = "${var.prefix}-${var.vpc_name}-${var.vm_db_resource_name}"
}
