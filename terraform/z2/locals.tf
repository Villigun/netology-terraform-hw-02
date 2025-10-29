locals {
  ssh_public_key = sensitive(file(var.ssh_public_key_path))
}