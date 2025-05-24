variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
  default = "https://proxmox.yourdomain.com:8006/api2/json"
}

variable "pm_api_token_id" {
  type        = string
  description = "Proxmox API token ID"
}

variable "pm_api_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive = true
}

variable "target_node" {
  description = "Proxmox node to deploy VMs on"
  type        = string
  default     = "proxmox01"
}

variable "template_name" {
  description = "Proxmox cloud-init template to clone from"
  type        = string
  default     = "ubuntu-2404-template"
}

variable "ssh_user" {
  description = "Default SSH user for Ansible"
  type        = string
  default     = "ansible"
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_bridge" {
  description = "Proxmox network bridge to attach"
  type        = string
  default     = "vmbr0"
}

variable "vm_subnet_base" {
  description = "Base subnet (e.g., '192.168.100')"
  type        = string
  default     = "192.168.100."
}

variable "starting_ip_suffix" {
  description = "Starting IP suffix (e.g., 10)"
  type        = number
  default     = 10
}

variable "gateway" {
  description = "Default gateway IP (e.g., '192.168.100.1')"
  type        = string
  default     = "192.168.100.1"
}

variable "cloud_init_user" {
  description = "Username to set for cloud-init"
  type        = string
  default     = "cloud-init"
}
