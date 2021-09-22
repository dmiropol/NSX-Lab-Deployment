
terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
      version = "~>3.2.1"
    }
    # vsphere = {
    #   version = "~> 2.0"
    # }
  }
}

provider "nsxt" {
  host                 = var.nsx_manager
  username             = var.nsx_user
  password             = var.nsx_password
  allow_unverified_ssl = true
}

/* 
provider "vsphere" {
  user           = var.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vcenter_server
  allow_unverified_ssl = true
}
 */