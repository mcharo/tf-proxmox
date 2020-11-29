# pve variables
pve_node = "pve"
api_user = "root@pam"
api_host = "pve.lan.example.org"
ssh_user = "root"

# vm variables
cpu_cores = 2
template  = "ubuntu-cloudinit"
vm_user   = "vmuser"
hostname  = "testvm-1"
domain    = "lan.example.org"
ssh_keys = [
  "/Users/user/.ssh/id_rsa.pub"
]