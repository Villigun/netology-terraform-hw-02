resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_ci_image
}

# ===== platform =====

#resource "yandex_compute_instance" "platform" {
  # name        = var.vm_web_name
  # platform_id = var.vm_web_platform
  # resources {
  #   cores         = var.vm_web_cores
  #   memory        = var.vm_web_memory
  #   core_fraction = var.vm_web_cfraction
  # }

  # Играемся с индексным списком
  # name        = local.vm_ci_platform[0]
  # zone        = local.vm_ci_platform[1]
  # platform_id = local.vm_ci_platform[2]
  # resources {
  #   cores         = local.vm_ci_platform[3]
  #   memory        = local.vm_ci_platform[4]
  #   core_fraction = local.vm_ci_platform[5]
  # }

  # name        = local.vm_ci_platform.name
  # zone        = local.vm_ci_platform.zone
  # platform_id = local.vm_ci_platform.platform_id
  # resources {
  #   cores         = local.vm_ci_platform.cores
  #   memory        = local.vm_ci_platform.memory
  #   core_fraction = local.vm_ci_platform.cfraction
  # }

  # boot_disk {
  #   initialize_params {
  #     image_id = data.yandex_compute_image.ubuntu.image_id
  #   }
  # }

resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_name
  zone        = var.vms_resources["web"].zone
  platform_id = var.vms_resources["web"].platform_id
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      size = var.vms_resources["web"].hdd_size
      type = var.vms_resources["web"].hdd_type
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys  = sensitive("${var.vm_web_user}:${local.ssh_public_key}")
  # }

  metadata = sensitive(var.metadata)
}

# ===== db =====

resource "yandex_vpc_subnet" "db" {
  name           = var.vpc2_name
  zone           = var.alternative_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.alternative_cidr
}

#resource "yandex_compute_instance" "db" {
  # name        = var.vm_db_name
  # platform_id = var.vm_db_platform
  # zone        = var.alternative_zone
  # resources {
  #   cores         = var.vm_db_cores
  #   memory        = var.vm_db_memory
  #   core_fraction = var.vm_db_cfraction
  # }

  # Играемся с индексным списком
  # name        = local.vm_ci_db[0]
  # zone        = local.vm_ci_db[1]
  # platform_id = local.vm_ci_db[2]
  # resources {
  #   cores         = local.vm_ci_db[3]
  #   memory        = local.vm_ci_db[4]
  #   core_fraction = local.vm_ci_db[5]
  # }
  
  # name        = local.vm_ci_db.name
  # zone        = local.vm_ci_db.zone
  # platform_id = local.vm_ci_db.platform_id
  # resources {
  #   cores         = local.vm_ci_db.cores
  #   memory        = local.vm_ci_db.memory
  #   core_fraction = local.vm_ci_db.cfraction
  # }  

  # boot_disk {
  #   initialize_params {
  #     image_id = data.yandex_compute_image.ubuntu.image_id
  #   }
  # }

resource "yandex_compute_instance" "db" {
  name        = local.vm_db_name
  zone        = var.vms_resources["db"].zone
  platform_id = var.vms_resources["db"].platform_id
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      size = var.vms_resources["db"].hdd_size
      type = var.vms_resources["db"].hdd_type
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.db.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys  = "${var.vm_web_user}:${local.ssh_public_key}"
  # }

  metadata = sensitive(var.metadata)
}