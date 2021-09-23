data "avi_cloud" "avi_cloud" {
  name = var.avi_cloud.cloud_name
}

data "avi_virtualservice" "webapp" {
  name = "webapp"
  cloud_ref = var.avi_cloud.cloud_name
}

data "avi_virtualservice" "secured-webapp" {
  name = "secured-webapp"
  cloud_ref = var.avi_cloud.cloud_name
}


data "avi_applicationprofile" "system_http" {
  name = "System-HTTP"
}

data "avi_applicationprofile" "system_https" {
  name = "System-HTTPS"
}
data "avi_networkprofile" "system_tcp_proxy" {
  name = "System-TCP-Proxy"
}

