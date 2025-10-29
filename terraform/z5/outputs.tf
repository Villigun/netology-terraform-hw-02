# output "platform_external_ip" {
#   description = "Внешний IP адрес виртуальной инстанса platform"
#   value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
# }

# output "db_external_ip" {
#   description = "Внешний IP адрес инстанса db"
#   value       = yandex_compute_instance.db.network_interface[0].nat_ip_address
# }

output "vm_info" {
  description = "Information about all VM instances"
  value = {
    for inst in [yandex_compute_instance.platform, yandex_compute_instance.db] :
    inst.name => {
      instance_name = inst.name
      external_ip   = inst.network_interface[0].nat_ip_address
      fqdn          = inst.fqdn
    }
  }
}