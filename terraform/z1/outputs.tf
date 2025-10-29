output "platform_external_ip" {
  description = "Внешний IP адрес виртуальной машины"
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}