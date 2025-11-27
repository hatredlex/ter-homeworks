variable "web_provision" {
  type        = bool
  default     = true
  description = "ansible provision switch variable"
}

resource "local_file" "ansible_inventory" {
  count = var.web_provision ? 1 : 0
  content = templatefile("${path.module}/ansible_hosts.tftpl", {
    webservers = [
      for w in yandex_compute_instance.web : {
        name = w.name
        ip   = w.network_interface[0].nat_ip_address
        fqdn = w.fqdn
      }
    ]

    databases = [
      for _, d in yandex_compute_instance.db : {
        name = d.name
        ip   = d.network_interface[0].nat_ip_address
        fqdn = d.fqdn
      }
    ]
    storage = {
      name = yandex_compute_instance.storage.name
      ip   = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn = yandex_compute_instance.storage.fqdn
    }
  })

  filename = "${path.module}/hosts.ini"
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage,
  ]
}
