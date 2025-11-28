variable "network_name" {
  type        = string
  description = "Имя сети"
}

variable "zone" {
  type        = string
  description = "Зона доступности"
}

variable "cidr" {
  type        = string
  description = "CIDR для подсети"
}
