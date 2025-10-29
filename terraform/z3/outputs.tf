output "platform_external_ip" {
  description = "Внешний IP адрес виртуальной инстанса platform"
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "db_external_ip" {
  description = "Внешний IP адрес инстанса db"
  value       = yandex_compute_instance.db.network_interface[0].nat_ip_address
}