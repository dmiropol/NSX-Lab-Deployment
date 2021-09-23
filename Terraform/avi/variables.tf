
variable "avi_provider" {
  type = map 
  default = { 
    avi_username = "admin"
    avi_password = "VMware1!" 
    avi_controller = "avictrl-01a.corp.local"
    avi_tenant     = "admin"
    avi_version = "20.1.4"
  }
}


variable "avi_cloud" {
  type = map 
  /* default = { 
    #cloud_name = "NSX-T_Cloud"
    #cloud_type = "CLOUD_NSXT"
    #cloud_name = "Default-Cloud" 
    #cloud_type = "CLOUD_VCENTER"
  } */
}

variable "webapp" {
  type = map 
  default = { 
    vs_name = "test_webapp_https_vs" 
    vs_vip = "172.16.12.6"
    vs_fqdn = "webapp.corp.local"
    vs_port = "80"
    pool_name = "test_webapp_https_pool" 
    lb_algorithm = "LB_ALGORITHM_ROUND_ROBIN"
    pool_server_1 = "172.16.10.14"
  }
}

variable "secured_webapp" {
  type = map 
  default = { 
    vs_name = "secured_webapp_https_vs" 
    vs_vip = "172.16.12.7"
    vs_fqdn = "secured_webapp.corp.local"
    vs_port = "443"
    pool_name = "secured_webapp_https_pool" 
    lb_algorithm = "LB_ALGORITHM_ROUND_ROBIN"
    pool_server_1 = "172.16.10.11"
    pool_server_2 = "172.16.10.12"
  }
}
