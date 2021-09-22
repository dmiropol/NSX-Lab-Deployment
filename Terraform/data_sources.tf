
// NSX data sources: TZ, edge nodes, cluster, etc...
data "nsxt_policy_transport_zone" "overlay_transport_zone" {
   display_name = "nsx-overlay-transportzone"
}

data "nsxt_policy_transport_zone" "uplinks_vlan_transport_zone" {
    display_name = "nsx-uplinks-vlan-transportzone"
}

data "nsxt_policy_edge_cluster" "EdgeCluster" {
    display_name = "EdgeCluster"
}

data "nsxt_policy_edge_node" "edgenode_01" {
    display_name        = var.nsxt_policy_edgenode_01
    edge_cluster_path   = data.nsxt_policy_edge_cluster.EdgeCluster.path
}

# services definitions
data "nsxt_policy_service" "service_icmp" {
  display_name = "ICMP ALL"
}

data "nsxt_policy_service" "service_ssh" {
  display_name = "SSH"
}


data "nsxt_policy_service" "service_http" {
  display_name = "HTTP"
}

data "nsxt_policy_service" "service_https" {
  display_name = "HTTPS"
}

data "nsxt_policy_service" "service_mysql" {
  display_name = "MySQL"
}

# Avi controller services
data "nsxt_policy_service" "avi-ControllerCluster" {
  display_name = "nsxt-ControllerCluster"
}

# Avi controller and SE groups
data "nsxt_policy_group" "avi-ControllerCluster" {
  display_name = "nsxt-ControllerCluster"
}

data "nsxt_policy_group" "avi-ServiceEngines" {
  display_name = "nsxt-ServiceEngines"
}

# Management IP group 
data "nsxt_policy_group" "mgmt_ip" {
  display_name = "Mgmt-IP"
}