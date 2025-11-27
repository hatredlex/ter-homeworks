locals {
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}
