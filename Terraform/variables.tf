//provider nsxt variables
variable "nsx_user" {
  default = "admin"
}

variable "nsx_password" {
  default = "VMware1!VMware1!"
}

variable "nsx_manager" {
  type = string
  #default = "nsxapp-01a.corp.local"
}

variable "nsxt_seg_left" {
  type = map 
  default = { 
    display_name = "left-seg", 
    vlan_ids = "240" 
  }
}

variable "nsxt_seg_right" {
  type = map
  default = {
    display_name = "right-seg", 
    vlan_ids = "250" 
  }
}

variable "nsxt_web_seg" {
  type = map
  default = {
    display_name = "web-seg", 
    cidr = "172.16.10.1/24"
  }
}

variable "nsxt_app_seg" {
  type = map
  default = {
    display_name = "app-seg", 
    cidr = "172.16.20.1/24" 
  }
}

variable "nsxt_db_seg" {
  type = map
  default = {
    display_name = "db-seg", 
    cidr = "172.16.30.1/24" 
  }
}

// avi segments
variable "nsxt_seg_avi_mgmt" {
  type = map
  default = {
    display_name = "avi-mgmt", 
    cidr = "172.16.11.1/24"
  }
}

variable "nsxt_seg_avi_data" {
  type = map
  default = {
    display_name = "avi-data", 
    cidr = "172.16.12.1/24"
  }
}


variable "nsxt_t1_gw" {
  type = map
  default = {
    display_name = "T1-GW"
    route_advertisement_types = "TIER1_CONNECTED"
  } 
}

//avi T1
variable "nsxt_t1_avi" {
  type = map
  default = {
    display_name = "T1-Avi"
    route_advertisement_types = "TIER1_CONNECTED"
  } 
}

variable "nsxt_t0_gw" {
  type = map
  default = {
    display_name = "T0-GW"
    intf_left_name = "left-intf"
    left_subnet = "192.168.240.11/24"
    intf_right_name = "right-intf"
    right_subnet = "192.168.250.11/24"
    redistribute_route_types = "TIER1_CONNECTED"
  } 
}

variable "nsxt_bgp_config" {
  type = map
  default = {
    local_as_num = 100
    remote_as_num = 200
    neighbor_name_left = "bgp-left"
    neighbor_address_left = "192.168.240.1"
    neighbor_name_right = "bgp-right"
    neighbor_address_right = "192.168.250.1"
    hold_down_time = 4
    keep_alive_time = 1
    bfd_nabled  = true
    bfd_interval = 500
    bfd_multiple = 3
  } 
}

variable "nsxt_policy_edgenode_01" {
  type = string 
  #default = "edgenode-01a"
}


variable "nsxt_group_rdsh" {
  type = map
  default = {
    display_name = "RDSH-Group"
    vm_name = "RDSH"
  }
}

variable "nsxt_group_fin_web" {
  type = map
  default = {
    display_name = "Fin-Web"
    vm_name = "srv-FinData"
  }
}

variable "nsxt_group_hr_web" {
  type = map
  default = {
    display_name = "HR-Web"
    vm_name = "phoenix-web-02"
  }
}


variable "nsxt_group_fin_users" {
  type = map
  default = {
    display_name = "Fin-Users"
  }
}

variable "nsxt_group_hr_users" {
  type = map
  default = {
    display_name = "HR-Users"
  }
}


variable "nsxt_group_web_vm" {
  type = map
  default = {
    display_name = "Web-VM-Group", 
    vm_tag = "web"
    vm_name = "web"
  }
}

variable "nsxt_group_app_vm" {
  type = map
  default = {
    display_name = "App-VM-Group", 
    vm_tag = "app"
    vm_name = "app"
  }
}

variable "nsxt_group_db_vm" {
  type = map
  default = {
    display_name = "Db-VM-Group", 
    vm_tag = "db"
    vm_name = "db"
  }
}

variable "nsxt_service_tcp8443" {
  type = map
  default = {
    display_name = "TCP_8443", 
    protocol = "TCP"
    destination_ports = "8443"
  }
}
