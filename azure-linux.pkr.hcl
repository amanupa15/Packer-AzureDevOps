packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "clientid" {
  type        = string
  default     = null
  sensitive   = true
}

variable "clientsecret" {
  type        = string
  default     = null
  sensitive   = true
}

variable "subscriptionid" {
  type        = string
  default     = null
  sensitive   = true
}

variable "tenantid" {
  type        = string
  default     = null
  sensitive   = true
}

source "azure-arm" "ubuntu" {
  client_id                         = var.clientid
  client_secret                     = var.clientsecret
  subscription_id                   = var.subscriptionid
  tenant_id                         = var.tenantid
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "18.04-LTS"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Ubuntu 18.04"
    Release    = "18.04"
  }

  location = "East US"
  vm_size  = "Standard_B2s"
}

build {
  name = "ubuntu"
  sources = [
    "source.azure-arm.ubuntu",
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
  }

  # Install Azure CLI
  provisioner "shell" {
    inline = ["curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"]
  }

  post-processor "manifest" {}

}