
terraform {
  required_providers {
    avi = {
      source = "vmware/avi"
      version = "~>21.1.1"
    }
  }
}

provider "avi" {
    avi_username   = var.avi_provider.avi_username
    avi_password   = var.avi_provider.avi_password
    avi_controller = var.avi_provider.avi_controller
    avi_tenant     = var.avi_provider.avi_tenant
    avi_version    = var.avi_provider.avi_version
}