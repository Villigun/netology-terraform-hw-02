# ===== Global variables =====

locals {
  ssh_public_key = sensitive(file(var.ssh_public_key_path))
}

# ===== names variables =====

locals {
  project       = "netology"
  env           = "develop"
  system        = "platform"

  vm_web_name   = "${local.project}-${local.env}-${local.system}-web"
  vm_db_name    = "${local.project}-${local.env}-${local.system}-db"
}

# ===== vm_web variables =====

# Играемся с индексным списком
# locals {
#   vm_ci_platform  = [
#     var.vm_web_name,
#     var.default_zone,
#     var.vm_web_platform,
#     var.vm_web_cores,
#     var.vm_web_memory,
#     var.vm_web_cfraction
#   ]  
# }

locals {
  vm_ci_platform  = {
    name        = local.vm_web_name,
    zone        = var.default_zone,
    platform_id = var.vm_web_platform,
    cores       = var.vm_web_cores,
    memory      = var.vm_web_memory,
    cfraction   = var.vm_web_cfraction
  }  
}

# ===== vm_db variables =====

# Играемся с индексным списком
# locals {
#   vm_ci_db  = [
#     var.vm_db_name,
#     var.alternative_zone,
#     var.vm_db_platform,
#     var.vm_db_cores,
#     var.vm_db_memory,
#     var.vm_db_cfraction
#   ]  
# }

locals {
  vm_ci_db  = {
    name        = local.vm_db_name,
    zone        = var.alternative_zone,
    platform_id = var.vm_db_platform,
    cores       = var.vm_db_cores,
    memory      = var.vm_db_memory,
    cfraction   = var.vm_db_cfraction
  }  
}

