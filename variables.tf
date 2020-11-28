variable "hostname" {
  type = string
}

variable "domain" {
  type = string
}

variable "pve_node" {
  type    = string
  default = "pve"
}

variable "api_user" {
  type    = string
  default = "root@pam"
}

variable "api_password" {
  type = string
}

variable "api_host" {
  type = string
}

variable "ssh_password" {
  type = string
}

variable "ssh_user" {
  type    = string
  default = "root"
}

variable "ssh_host" {
  type    = string
  default = ""
}

variable "ssh_keys" {
  type = list(string)
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "cpu_sockets" {
  type    = number
  default = 1
}

variable "cpu_cores" {
  type    = number
  default = 1
}

variable "disk_gb" {
  type    = number
  default = 40
}

variable "disk_storage" {
  type    = string
  default = "local-lvm"
}

variable "network_model" {
  type    = string
  default = "virtio"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "template" {
  type    = string
  default = "ubuntu-cloudinit"
}

variable "vm_user" {
  type = string
}

variable "vm_password" {
  type = string
}