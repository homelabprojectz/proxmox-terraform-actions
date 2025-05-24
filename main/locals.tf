locals {
    # Proxmox VM Configuration
    # This is where you define the VMs you want to create
    proxmox_vm_qemu = {
        "205" = {
            name        = "docker01"
            clone       = "ubuntu-2404-template"
            target_node = "proxmox01"
            tags        = "ubuntu-24.04"
            memory      = 4096
            cores       = 2
            disk_size   = "16G"
            ipconfig0   = "ip=192.168.100.10/24,gw=192.168.100.1"
        }
        "206" = {
            name        = "docker02"
            clone       = "ubuntu-2404-template"
            target_node = "proxmox01"
            tags        = "ubuntu-24.04"
            memory      = 4096
            cores       = 2
            disk_size   = "16G"
            ipconfig0   = "ip=192.168.100.11/24,gw=192.168.100.1"
        }
        "207" = {
            name        = "docker03"
            clone       = "ubuntu-2404-template"
            target_node = "proxmox01"
            tags        = "ubuntu-24.04;docker"
            memory      = 4096
            cores       = 2
            disk_size   = "16G"
            ipconfig0   = "ip=192.168.100.12/24,gw=192.168.100.1"
        }
    }
}