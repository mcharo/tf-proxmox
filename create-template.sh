# Create the instance
qm create 9000 -name ubuntu-cloudinit -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1

# Import the disk image to Proxmox storage
image_file=/var/lib/vz/template/iso/focal-server-cloudimg-amd64.img
if [ ! -f "$image_file" ]; then
    wget https://cloud-images.ubuntu.com/bionic/current/focal-server-cloudimg-amd64.img -O $image_file
fi
qm importdisk 9000 $image_file local-lvm

# Attach the disk to the virtual machine
qm set 9000 -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-9000-disk-0

# Add a serial output
qm set 9000 -serial0 socket

# Set the bootdisk to the imported Openstack disk
qm set 9000 -boot c -bootdisk virtio0

# Enable the Qemu agent
qm set 9000 -agent 1

# Allow hotplugging of network, USB and disks
qm set 9000 -hotplug disk,network,usb

# Add a single vCPU (for now)
qm set 9000 -vcpus 1

# Add a video output
qm set 9000 -vga qxl

# Set a second hard drive, using the inbuilt cloudinit drive
qm set 9000 -ide2 local-lvm:cloudinit

# Resize the primary boot disk (otherwise it will be around 2G by default)
# This step adds another 8G of disk space, but change this as you need to
qm resize 9000 virtio0 +8G

# Convert the VM to the template
qm template 9000