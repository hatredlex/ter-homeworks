### Disks for storage
resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name = "storage-disk-${count.index + 1}"
  size = 1
  type = "network-hdd"
  zone = var.default_zone
}

### VM Storage
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v2"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.metadata

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = true
    }
  }
}
