###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "<your_ssh_ed25519_key>"
#   description = "ssh-keygen -t ed25519"
# }

variable "ssh_public_key_path" {
  description = "Путь к SSH публичному ключу"
  type        = string
}





variable "vm_web_ci_image" {
  type        = string
  description = "Семейство образов для ВМ web"
  default     = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type        = string
  description = "Имя виртуальной машины web"
  default     = "netology-develop-platform-web"
}

variable "vm_web_platform" {
  type        = string
  description = "Платформа ВМ (standard-v1, standard-v4a)"
  default     = "standard-v1"
}

variable "vm_web_cores" {
  type        = number
  description = "Количество ядер CPU"
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  description = "Объем памяти в GB"
  default     = 1
}

variable "vm_web_cfraction" {
  type        = number
  description = "% резервирования CPU"
  default     = 5
}

variable "vm_web_user" {
  type        = string
  description = "Имя пользователя ВМ, по умолчанию в yc - ubuntu"
  default     = "ubuntu"
}