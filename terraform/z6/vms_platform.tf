###cloud vars

### ===== Global variables ===== ###

# variable "vm_web_user" {
#   type        = string
#   description = "Имя пользователя ВМ, по умолчанию в yc - ubuntu"
#   default     = "ubuntu"
# }

# variable "ssh_public_key_path" {
#   description = "Путь к SSH публичному ключу"
#   type        = string
# }

### ===== vm_web variables ===== ###

variable "vm_web_ci_image" {
  type        = string
  description = "Семейство образов для ВМ web"
  default     = "ubuntu-2004-lts"
}

# variable "vm_web_name" {
#   type        = string
#   description = "Имя виртуальной машины web"
#   default     = "netology-develop-platform-web"
# }

# variable "vm_web_platform" {
#   type        = string
#   description = "Платформа ВМ (standard-v1, standard-v4a)"
#   default     = "standard-v1"
# }

# variable "vm_web_cores" {
#   type        = number
#   description = "Количество ядер CPU"
#   default     = 2
# }

# variable "vm_web_memory" {
#   type        = number
#   description = "Объем памяти в GB"
#   default     = 1
# }

# variable "vm_web_cfraction" {
#   type        = number
#   description = "% резервирования CPU"
#   default     = 5
# }

### ===== vm_db variables ===== ###

# variable "vm_db_ci_image" {
#   type        = string
#   description = "Семейство образов для ВМ web"
#   default     = "ubuntu-2004-lts"
# }

# variable "vm_db_name" {
#   type        = string
#   description = "Имя виртуальной машины web"
#   default     = "netology-develop-platform-db"
# }

# variable "vm_db_platform" {
#   type        = string
#   description = "Платформа ВМ (standard-v1, standard-v4a)"
#   default     = "standard-v1"
# }

# variable "vm_db_cores" {
#   type        = number
#   description = "Количество ядер CPU"
#   default     = 2
# }

# variable "vm_db_memory" {
#   type        = number
#   description = "Объем памяти в GB"
#   default     = 2
# }

# variable "vm_db_cfraction" {
#   type        = number
#   description = "% резервирования CPU"
#   default     = 20
# }