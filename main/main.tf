resource "proxmox_vm_qemu" "prod" {
    # Default Hardware Values
    # These values are set to defaults, but can be overridden in the locals.tf file
    for_each    = local.proxmox_vm_qemu
    name        = each.value.name
    target_node = each.value.target_node
    clone       = lookup(each.value, "clone", "ubuntu-2404-template")
    os_type     = lookup(each.value, "os_type", "cloud-init")
    tags        = lookup(each.value, "tags", "Ubuntu")
    vmid        = each.key
    cores       = lookup(each.value, "cores", 2)
    memory      = lookup(each.value, "memory", 2048)
    scsihw      = lookup(each.value, "scsihw", "virtio-scsi-single")
    cpu_type    = lookup(each.value, "cpu_type", "host")

    disks {
        ide{
            ide0{
                cloudinit {
                    storage = lookup(each.value, "cloudinit_storage", "local-lvm")
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = lookup(each.value, "disk_size", "16G")
                    storage         = lookup(each.value, "disk_storage", "local-lvm")
                }
            }
        }
    }

    network {
        id      = lookup(each.value, "network_id", 0)
        model   = lookup(each.value, "network_model", "virtio")
        bridge  = lookup(each.value, "network_bridge", "vmbr0")
    }

    serial {
        id      = lookup(each.value, "serial_id", 0)
        type    = lookup(each.value, "serial_type", "socket")
    }

    #Cloud-Init
    ciuser          = lookup(each.value, "ciuser", "sysadmin")
    ciupgrade       = lookup(each.value, "ciupgrade", true)
    ipconfig0       = lookup(each.value, "ipconfig0", "")
    nameserver      = lookup(each.value, "nameserver", "192.168.100.1")
    # ssh key file below is referencing the one on your self hosted runner, unless you
    # keep your ssh keys in a different location / in your proxmox template
    sshkeys         = lookup(each.value, "sshkeys", file("~/.ssh/id_rsa.pub"))

    # Options
    agent           = lookup(each.value, "agent", 1)
    onboot          = lookup(each.value, "onboot", true)
}