# Yandex Cloud
cloud_id          = "bpfu4re2q34iv1qqnh4n"  # Cloud ID
folder_id         = "b1g57c69inml3980vmeg"  # Folder ID
default_zone      = "ru-central1-a"         # Default zone
alternative_zone  = "ru-central1-b"         # Alternative zone

# SSH-key patch
# ssh_public_key_path = "Путь к SSH-ключу"

# Ресурсы ВМок
vms_resources = {
  web={
    name="netology-develop-platform-web"
    zone="ru-central1-a"
    platform_id="standard-v1"
    cores=2
    memory=2
    core_fraction=5
    hdd_size=10
    hdd_type="network-hdd"
  },
  db= {
    name="netology-develop-platform-db"
    zone="ru-central1-b"
    platform_id="standard-v1"    
    cores=2
    memory=4
    core_fraction=20
    hdd_size=10
    hdd_type="network-ssd"
  }
}

metadata = {
  serial-port-enable = 1
  # !!! Ахтунг !!! Не забудь удалить ключ!
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC - а вот и нет"
}