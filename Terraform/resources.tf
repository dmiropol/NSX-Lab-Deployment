
###########################
# segments definition
###########################

// infra segments
resource "nsxt_policy_vlan_segment" "left-seg" {
  display_name        = var.nsxt_seg_left.display_name
  nsx_id              = var.nsxt_seg_left.display_name
  transport_zone_path = data.nsxt_policy_transport_zone.uplinks_vlan_transport_zone.path
  vlan_ids            = [var.nsxt_seg_left.vlan_ids]
}

resource "nsxt_policy_vlan_segment" "right-seg" {
  display_name        = var.nsxt_seg_right.display_name
  nsx_id              = var.nsxt_seg_right.display_name
  transport_zone_path = data.nsxt_policy_transport_zone.uplinks_vlan_transport_zone.path
  vlan_ids            = [var.nsxt_seg_right.vlan_ids]
}

// Application segments
resource "nsxt_policy_segment" "web_segment" {
  display_name      = var.nsxt_web_seg.display_name
  nsx_id            = var.nsxt_web_seg.display_name
  connectivity_path = nsxt_policy_tier1_gateway.t1_gw.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_transport_zone.path
  subnet {
    cidr = var.nsxt_web_seg.cidr
  }
  advanced_config {
    connectivity = "ON"
  }
}

resource "nsxt_policy_segment" "app_segment" {
  display_name      = var.nsxt_app_seg.display_name
  nsx_id            = var.nsxt_app_seg.display_name
  connectivity_path = nsxt_policy_tier1_gateway.t1_gw.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_transport_zone.path
  subnet {
    cidr = var.nsxt_app_seg.cidr
  }
  advanced_config {
    connectivity = "ON"
  }
}

resource "nsxt_policy_segment" "db_segment" {
  display_name      = var.nsxt_db_seg.display_name
  nsx_id            = var.nsxt_db_seg.display_name
  connectivity_path = nsxt_policy_tier1_gateway.t1_gw.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_transport_zone.path
  subnet {
    cidr = var.nsxt_db_seg.cidr
  }
  advanced_config {
    connectivity = "ON"
  }
}


// segments for Avi SE 
resource "nsxt_policy_segment" "avi_mgmt" {
  display_name      = var.nsxt_seg_avi_mgmt.display_name
  nsx_id            = var.nsxt_seg_avi_mgmt.display_name
  connectivity_path = nsxt_policy_tier1_gateway.t1_avi.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_transport_zone.path
  subnet {
    cidr = var.nsxt_seg_avi_mgmt.cidr
  }
  advanced_config {
    connectivity = "ON"
  }
}

resource "nsxt_policy_segment" "avi_data" {
  display_name      = var.nsxt_seg_avi_data.display_name
  nsx_id            = var.nsxt_seg_avi_data.display_name
  connectivity_path = nsxt_policy_tier1_gateway.t1_avi.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_transport_zone.path
  subnet {
    cidr = var.nsxt_seg_avi_data.cidr
  }
  advanced_config {
    connectivity = "ON"
  }
}

###########################
# T1 gateway definition
###########################
resource "nsxt_policy_tier1_gateway" "t1_gw" {
  display_name = var.nsxt_t1_gw.display_name
  nsx_id       = var.nsxt_t1_gw.display_name
  tier0_path   = nsxt_policy_tier0_gateway.t0_gw.path
  route_advertisement_types = [var.nsxt_t1_gw.route_advertisement_types]
  /* no edge cluster needed, only DR is in use
  edge_cluster_path         = data.nsxt_policy_edge_cluster.EdgeCluster.path
  */
}

# T1 Avi gateway definition
resource "nsxt_policy_tier1_gateway" "t1_avi" {
  display_name = var.nsxt_t1_avi.display_name
  nsx_id       = var.nsxt_t1_avi.display_name
  tier0_path   = nsxt_policy_tier0_gateway.t0_gw.path
  route_advertisement_types = [var.nsxt_t1_avi.route_advertisement_types]
}

###########################
# T0 gateway definition
###########################
resource "nsxt_policy_tier0_gateway" "t0_gw" {
  display_name              = var.nsxt_t0_gw.display_name
  nsx_id                    = var.nsxt_t0_gw.display_name
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = false
  enable_firewall           = false
  edge_cluster_path         = data.nsxt_policy_edge_cluster.EdgeCluster.path
}

resource "nsxt_policy_gateway_redistribution_config" "t0_redistribute" {
  gateway_path = nsxt_policy_tier0_gateway.t0_gw.path
  bgp_enabled = true
  rule {
    name  = var.nsxt_t0_gw.redistribute_route_types
    types = [var.nsxt_t0_gw.redistribute_route_types]
  }
  # rule {
  #   name  = "TIER0_CONNECTED"
  #   types = ["TIER0_CONNECTED"]
  # }
}

resource "nsxt_policy_tier0_gateway_interface" "left-intf" {
  display_name           = var.nsxt_t0_gw.intf_left_name
  nsx_id                 = var.nsxt_t0_gw.intf_left_name
  type                   = "EXTERNAL"
  gateway_path           = nsxt_policy_tier0_gateway.t0_gw.path
  segment_path           = nsxt_policy_vlan_segment.left-seg.path
  edge_node_path         = data.nsxt_policy_edge_node.edgenode_01.path
  subnets                = [var.nsxt_t0_gw.left_subnet]
}

resource "nsxt_policy_tier0_gateway_interface" "right-intf" {
  display_name           = var.nsxt_t0_gw.intf_right_name
  nsx_id                 = var.nsxt_t0_gw.intf_right_name
  type                   = "EXTERNAL"
  gateway_path           = nsxt_policy_tier0_gateway.t0_gw.path
  segment_path           = nsxt_policy_vlan_segment.right-seg.path
  edge_node_path         = data.nsxt_policy_edge_node.edgenode_01.path
  subnets                = [var.nsxt_t0_gw.right_subnet]
}

###########################
# BGP configuration
###########################
resource "nsxt_policy_bgp_config" "bgp_t0" {
  gateway_path          = nsxt_policy_tier0_gateway.t0_gw.path
  enabled               = true
  inter_sr_ibgp         = true
  local_as_num          = var.nsxt_bgp_config.local_as_num
  graceful_restart_mode = "HELPER_ONLY"
}

resource "nsxt_policy_bgp_neighbor" "bgp_left" {
  display_name          = var.nsxt_bgp_config.neighbor_name_left
  nsx_id                = var.nsxt_bgp_config.neighbor_name_left
  bgp_path              = nsxt_policy_bgp_config.bgp_t0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = var.nsxt_bgp_config.hold_down_time
  keep_alive_time       = var.nsxt_bgp_config.keep_alive_time
  neighbor_address      = var.nsxt_bgp_config.neighbor_address_left
  remote_as_num         = var.nsxt_bgp_config.remote_as_num
  source_addresses      = [nsxt_policy_tier0_gateway_interface.left-intf.ip_addresses[0]]
  bfd_config {
    enabled  = var.nsxt_bgp_config.bfd_nabled
    interval = var.nsxt_bgp_config.bfd_interval
    multiple = var.nsxt_bgp_config.bfd_multiple
  }
}

resource "nsxt_policy_bgp_neighbor" "bgp_right" {
  display_name          = var.nsxt_bgp_config.neighbor_name_right
  nsx_id                = var.nsxt_bgp_config.neighbor_name_right
  bgp_path              = nsxt_policy_bgp_config.bgp_t0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = var.nsxt_bgp_config.hold_down_time
  keep_alive_time       = var.nsxt_bgp_config.keep_alive_time
  neighbor_address      = var.nsxt_bgp_config.neighbor_address_right
  remote_as_num         = var.nsxt_bgp_config.remote_as_num
  source_addresses      = [nsxt_policy_tier0_gateway_interface.right-intf.ip_addresses[0]]
  bfd_config {
    enabled  = var.nsxt_bgp_config.bfd_nabled
    interval = var.nsxt_bgp_config.bfd_interval
    multiple = var.nsxt_bgp_config.bfd_multiple
  }
}

###########################
# Security groups definitions
###########################
resource "nsxt_policy_group" "web_vm_group" {
  display_name = var.nsxt_group_web_vm.display_name
  nsx_id       = var.nsxt_group_web_vm.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      key         = "Tag"
      value       = var.nsxt_group_web_vm.vm_tag
    }
  }
  conjunction {
    operator = "OR"
  }
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Name"
      value       = var.nsxt_group_web_vm.vm_name
    }
  }
}

resource "nsxt_policy_group" "app_vm_group" {
  display_name = var.nsxt_group_app_vm.display_name
  nsx_id       = var.nsxt_group_app_vm.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      key         = "Tag"
      value       = var.nsxt_group_app_vm.vm_tag
    }
  }
  conjunction {
    operator = "OR"
  }
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Name"
      value       = var.nsxt_group_app_vm.vm_name
    }
  }
}
resource "nsxt_policy_group" "db_vm_group" {
  display_name = var.nsxt_group_db_vm.display_name
  nsx_id       = var.nsxt_group_db_vm.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      key         = "Tag"
      value       = var.nsxt_group_db_vm.vm_tag
    }
  }
  conjunction {
    operator = "OR"
  }
  criteria {
    condition {
      key         = "Name"
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      value       = var.nsxt_group_db_vm.vm_name
    }
  }
}

resource "nsxt_policy_group" "rdsh_group" {
  display_name = var.nsxt_group_rdsh.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Name"
      value       = var.nsxt_group_rdsh.vm_name
    }
  }
}


resource "nsxt_policy_group" "fin_web_group" {
  display_name = var.nsxt_group_fin_web.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Name"
      value       = var.nsxt_group_fin_web.vm_name
    }
  }
}

resource "nsxt_policy_group" "hr_web_group" {
  display_name = var.nsxt_group_hr_web.display_name
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Name"
      value       = var.nsxt_group_hr_web.vm_name
    }
  }
}

resource "nsxt_policy_group" "fin_users_group" {
  display_name = var.nsxt_group_fin_users.display_name
  extended_criteria {
    identity_group {
      distinguished_name             = "CN=FIN,CN=Users,DC=corp,DC=local"
      domain_base_distinguished_name = "DC=corp,DC=local"
    }
  }
}

resource "nsxt_policy_group" "hr_users_group" {
  display_name = var.nsxt_group_hr_users.display_name
  extended_criteria {
    identity_group {
      distinguished_name             = "CN=HR,CN=Users,DC=corp,DC=local"
      domain_base_distinguished_name = "DC=corp,DC=local"
    }
  }
}

//service definition
resource "nsxt_policy_service" "service_https_8443" {
  display_name = var.nsxt_service_tcp8443.display_name
  l4_port_set_entry {
    display_name      = var.nsxt_service_tcp8443.display_name
    protocol          = var.nsxt_service_tcp8443.protocol
    destination_ports = [var.nsxt_service_tcp8443.destination_ports]
  }
}

##########################
# DFW policy configuration
##########################
resource "nsxt_policy_security_policy" "management-access" {
  display_name = "Management Access"
  category     = "Infrastructure"
  rule {
    display_name       = "Management SSH + ICMP"
    source_groups      = [data.nsxt_policy_group.mgmt_ip.path]
    destination_groups = [nsxt_policy_group.db_vm_group.path, nsxt_policy_group.app_vm_group.path, nsxt_policy_group.web_vm_group.path]
    services           = [data.nsxt_policy_service.service_ssh.path, data.nsxt_policy_service.service_icmp.path]
    scope              = [nsxt_policy_group.db_vm_group.path, nsxt_policy_group.app_vm_group.path, nsxt_policy_group.web_vm_group.path]
    action             = "ALLOW"
  }
}

resource "nsxt_policy_security_policy" "Avi-infra" {
  display_name = "Avi-infra"
  category     = "Infrastructure"
  rule {
    display_name       = "Avi se to Controller"
    source_groups      = [data.nsxt_policy_group.avi-ServiceEngines.path]
    destination_groups = [data.nsxt_policy_group.avi-ControllerCluster.path]
    services           = [data.nsxt_policy_service.avi-ControllerCluster.path]
    scope              = [data.nsxt_policy_group.avi-ServiceEngines.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "Avi Controller out"
    source_groups      = [data.nsxt_policy_group.avi-ControllerCluster.path]
    services           = [data.nsxt_policy_service.avi-ControllerCluster.path]
    action             = "ALLOW"
  }
}


resource "nsxt_policy_security_policy" "Avi-Policy" {
  display_name = "Avi-Policy"
  category     = "Application"
  sequence_number = 10
  rule {
    display_name       = "Access to VIP"
    source_groups      = [data.nsxt_policy_group.mgmt_ip.path]
    destination_groups = ["172.16.12.6","172.16.12.7"]
    services           = [data.nsxt_policy_service.service_http.path,data.nsxt_policy_service.service_https.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "VIP to App"
    source_groups      = [data.nsxt_policy_group.avi-ServiceEngines.path]
    destination_groups = [nsxt_policy_group.web_vm_group.path]
    services           = [data.nsxt_policy_service.service_http.path,data.nsxt_policy_service.service_https.path]
    scope              = [nsxt_policy_group.web_vm_group.path,data.nsxt_policy_group.avi-ServiceEngines.path]
    action             = "ALLOW"
  }
}


resource "nsxt_policy_security_policy" "Phoenix_App" {
  display_name = "Phoenix_App"
  category     = "Application"
  stateful     = true
  sequence_number = 20
  rule {
    display_name       = "Any to Web"
    destination_groups = [nsxt_policy_group.web_vm_group.path]
    scope              = [nsxt_policy_group.web_vm_group.path]
    services           = [data.nsxt_policy_service.service_https.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "Web to App"
    source_groups      = [nsxt_policy_group.web_vm_group.path]
    destination_groups = [nsxt_policy_group.app_vm_group.path]
    scope              = [nsxt_policy_group.app_vm_group.path,nsxt_policy_group.web_vm_group.path]
    services           = [nsxt_policy_service.service_https_8443.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "App to DB"
    source_groups      = [nsxt_policy_group.app_vm_group.path]
    destination_groups = [nsxt_policy_group.db_vm_group.path]
    scope              = [nsxt_policy_group.app_vm_group.path,nsxt_policy_group.db_vm_group.path]
    services           = [data.nsxt_policy_service.service_mysql.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "Deny All"
    destination_groups = [nsxt_policy_group.web_vm_group.path,nsxt_policy_group.app_vm_group.path,nsxt_policy_group.db_vm_group.path]
    scope              = [nsxt_policy_group.web_vm_group.path,nsxt_policy_group.app_vm_group.path,nsxt_policy_group.db_vm_group.path]
    action             = "REJECT"
    logged             = true
    log_label          = "phoenix-deny" 
  }
}

resource "nsxt_policy_security_policy" "RDSH" {
  display_name = "RDSH"
  nsx_id       = "RDSH"
  category     = "Application"
  sequence_number = 30
  rule {
    display_name       = "access to RDSH"
    source_groups      = [data.nsxt_policy_group.mgmt_ip.path]
    destination_groups = [nsxt_policy_group.rdsh_group.path]
    scope              = [nsxt_policy_group.rdsh_group.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "Fin Rule"
    source_groups      = [nsxt_policy_group.fin_users_group.path]
    destination_groups = [nsxt_policy_group.fin_web_group.path]
    scope              = [nsxt_policy_group.rdsh_group.path]
    services           = [data.nsxt_policy_service.service_http.path,data.nsxt_policy_service.service_https.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "HR Rule"
    source_groups      = [nsxt_policy_group.hr_users_group.path]
    destination_groups = [nsxt_policy_group.hr_web_group.path]
    scope              = [nsxt_policy_group.rdsh_group.path]
    services           = [data.nsxt_policy_service.service_https.path]
    action             = "ALLOW"
  }
  rule {
    display_name       = "Deny Others"
    destination_groups = [nsxt_policy_group.hr_web_group.path,nsxt_policy_group.fin_web_group.path]
    scope              = [nsxt_policy_group.rdsh_group.path]
    action             = "REJECT"
    logged             = true
    log_label          = "rdsh-deny"
  }
}

