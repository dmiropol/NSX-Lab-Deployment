// Avi resources creation for http webapp

resource "avi_pool" "webapp_http_pool" {
   name = var.webapp.pool_name
   lb_algorithm = var.webapp.lb_algorithm
   cloud_ref = data.avi_cloud.avi_cloud.id
   default_server_port = var.webapp.vs_port
   servers {
      ip {
         type = "V4"
         addr = var.webapp.pool_server_1
      }
   }
   analytics_policy {
    enable_realtime_metrics = true
   }
}


resource "avi_vsvip" "webapp_vsvip" {
  name = var.webapp.vs_name
  cloud_ref = data.avi_cloud.avi_cloud.id
  vip {
    vip_id = 0
    ip_address {
        addr = var.webapp.vs_vip
        type = "V4"
    }
  }
  dns_info {
    fqdn = var.webapp.vs_fqdn
  }
}

resource "avi_virtualservice" "test_webapp_vs" {
  name = var.webapp.vs_name
  tenant_ref = var.avi_provider.avi_tenant
  cloud_type = var.avi_cloud.cloud_type
  cloud_ref = data.avi_cloud.avi_cloud.id
  vsvip_ref = avi_vsvip.webapp_vsvip.id
  pool_ref = avi_pool.webapp_http_pool.id
  application_profile_ref = data.avi_applicationprofile.system_http.id
  network_profile_ref = data.avi_networkprofile.system_tcp_proxy.id
  services {
    port = var.webapp.vs_port
    enable_ssl = false
  }
  analytics_policy {
    metrics_realtime_update {
      enabled  = true
      duration = 0
    }
  }
}



// Avi resources creation for https webapp
resource "avi_pool" "secured_webapp_https_pool" {
   name = var.secured_webapp.pool_name
   lb_algorithm = var.secured_webapp.lb_algorithm
   cloud_ref = data.avi_cloud.avi_cloud.id
   default_server_port = var.secured_webapp.vs_port
   servers {
      ip {
         type = "V4"
         addr = var.secured_webapp.pool_server_1
      }
      ip {
         type = "V4"
         addr = var.secured_webapp.pool_server_2
      }
   }
   analytics_policy {
    enable_realtime_metrics = true
   }
}


resource "avi_vsvip" "secured_webapp_vsvip" {
  name = var.secured_webapp.vs_name
  cloud_ref = data.avi_cloud.avi_cloud.id
  vip {
    vip_id = 0
    ip_address {
        addr = var.secured_webapp.vs_vip
        type = "V4"
    }
  }
  dns_info {
    fqdn = var.secured_webapp.vs_fqdn
  }
}

resource "avi_virtualservice" "secured_webapp_vs" {
  name = var.secured_webapp.vs_name
  tenant_ref = var.avi_provider.avi_tenant
  cloud_type = var.avi_cloud.cloud_type
  cloud_ref = data.avi_cloud.avi_cloud.id
  vsvip_ref = avi_vsvip.secured_webapp_vsvip.id
  pool_ref = avi_pool.secured_webapp_https_pool.id
  application_profile_ref = data.avi_applicationprofile.system_https.id
  network_profile_ref = data.avi_networkprofile.system_tcp_proxy.id
  services {
    port = var.secured_webapp.vs_port
    enable_ssl = true
  }
  analytics_policy {
    metrics_realtime_update {
      enabled  = true
      duration = 0
    }
  }
}
