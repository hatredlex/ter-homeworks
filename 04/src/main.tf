/*resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}*/

module "vpc_dev" {
  source       = "./vpc"
  network_name = var.vpc_name
  zone         = var.default_zone
  cidr         = var.default_cidr[0]
}

module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
#  network_id     = yandex_vpc_network.develop.id
#  subnet_ids     = [yandex_vpc_subnet.develop.id]
#  subnet_zones   = ["ru-central1-a"]
  network_id   = module.vpc_dev.network_id
  subnet_zones = [var.default_zone]
  subnet_ids   = [module.vpc_dev.subnet.id]
  instance_name  = "marketing-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
#  network_id     = yandex_vpc_network.develop.id
#  subnet_ids     = [yandex_vpc_subnet.develop.id]
#  subnet_zones   = ["ru-central1-a"]
  network_id   = module.vpc_dev.network_id
  subnet_zones = [var.default_zone]
  subnet_ids   = [module.vpc_dev.subnet.id]
  instance_name  = "analytics-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key = var.ssh_public_key
  }
}