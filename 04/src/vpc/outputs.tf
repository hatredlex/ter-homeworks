output "subnet" {
  description = "объект созданной подсети"
  value       = yandex_vpc_subnet.this
}

output "network_id" {
  description = "ID сети"
  value       = yandex_vpc_network.this.id
}
