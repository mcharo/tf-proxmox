terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.5"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.api_host}:8006/api2/json"
  pm_user         = var.api_user
  pm_password     = var.api_password
  pm_tls_insecure = true
}

locals {
  ssh_host = var.ssh_host == "" ? var.api_host : var.ssh_host
}

resource "local_file" "cloud_init_user_data_file" {
  content = templatefile("${path.module}/cloud_init.template", {
    hostname    = var.hostname
    fqdn        = "${var.hostname}.${var.domain}"
    vm_user     = var.vm_user
    vm_password = var.vm_password
    ssh_keys    = var.ssh_keys
  })
  filename = "${path.module}/cloud_init.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = local.ssh_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file.filename
    destination = "/var/lib/vz/snippets/user_data_vm.yml"
  }
}

resource "proxmox_vm_qemu" "ubuntu" {
  name        = var.hostname
  target_node = var.pve_node

  os_type = "cloud-init"
  clone   = var.template

  agent    = 1
  memory   = var.memory_mb
  sockets  = var.cpu_sockets
  cores    = var.cpu_cores
  bootdisk = "scsi0"
  scsihw   = "virtio-scsi-pci"

  ipconfig0 = "ip=dhcp"

  disk {
    size    = "${var.disk_gb}G"
    type    = "scsi"
    storage = var.disk_storage
  }

  network {
    model  = var.network_model
    bridge = var.network_bridge
  }

  lifecycle {
    ignore_changes = [
      network
    ]
  }

  cicustom = "user=local:snippets/user_data_vm.yml"

}
