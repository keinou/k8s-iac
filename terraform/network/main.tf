resource "oci_core_vcn" "cluster_network" {
  compartment_id = var.compartment_id

  cidr_blocks = var.cidr_blocks

  display_name = var.network_name
  dns_label    = var.network_dns_label
}

resource "oci_core_default_security_list" "default_list" {
  manage_default_resource_id = oci_core_vcn.cluster_network.default_security_list_id

  display_name = "Outbound only (default)"

  egress_security_rules {
    protocol    = "all" // TCP
    description = "Allow outbound"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol    = "all"
    description = "Allow inter-subnet traffic"
    source      = var.cidr_blocks[0]
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  enabled        = true
}

resource "oci_core_default_route_table" "internet_route_table" {
  compartment_id             = var.compartment_id
  manage_default_resource_id = oci_core_vcn.cluster_network.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "cluster_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.cluster_network.id
  cidr_block        = oci_core_vcn.cluster_network.cidr_blocks[0]
  display_name      = "cluster subnet"
  security_list_ids = [oci_core_vcn.cluster_network.default_security_list_id]
}

resource "oci_core_network_security_group" "permit_ssh" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit SSH"
}

resource "oci_core_network_security_group_security_rule" "permit_ssh" {
  for_each = { for idx, ip in var.ssh_managemnet_network : idx => ip }
  network_security_group_id = oci_core_network_security_group.permit_ssh.id
  protocol                  = "6" // TCP
  source                    = each.value
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_kubeapi" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit KubeAPI"
}

resource "oci_core_network_security_group_security_rule" "permit_kubeapi" {
  network_security_group_id = oci_core_network_security_group.permit_kubeapi.id
  protocol                  = "6" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_http" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit HTTP"
}

resource "oci_core_network_security_group_security_rule" "permit_http" {
  network_security_group_id = oci_core_network_security_group.permit_http.id
  protocol                  = "6" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_https" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit HTTPS"
}

resource "oci_core_network_security_group_security_rule" "permit_https" {
  network_security_group_id = oci_core_network_security_group.permit_https.id
  protocol                  = "6" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_rdp" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit XRDP"
}

resource "oci_core_network_security_group_security_rule" "permit_rdp" {
  for_each = { for idx, ip in var.developers_ips : idx => ip }
  network_security_group_id = oci_core_network_security_group.permit_rdp.id
  protocol                  = "6" // TCP
  source                    = each.value
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 3389
      max = 3389
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_developers" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit Node Ports for Developers"
}

resource "oci_core_network_security_group_security_rule" "permit_developers" {
  for_each = { for idx, ip in var.developers_ips : idx => ip }
  network_security_group_id = oci_core_network_security_group.permit_developers.id
  protocol                  = "6" // TCP
  source                    = each.value
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 31432
      max = 31434
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group" "permit_zomboid" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Permit Project Zomboid Ports"
}

resource "oci_core_network_security_group_security_rule" "permit_zomboid" {
  network_security_group_id = oci_core_network_security_group.permit_zomboid.id
  protocol                  = "17" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  
  udp_options  {
    destination_port_range {
      min = 8766
      max = 8766
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group_security_rule" "permit_zomboid2" {
  network_security_group_id = oci_core_network_security_group.permit_zomboid.id
  protocol                  = "17" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  
  udp_options  {
    destination_port_range {
      min = 16261
      max = 16261
    }
  }
  direction = "INGRESS"
}

resource "oci_core_network_security_group_security_rule" "permit_zomboid3" {
  network_security_group_id = oci_core_network_security_group.permit_zomboid.id
  protocol                  = "17" // TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  
  udp_options  {
    destination_port_range {
      min = 16262
      max = 16262
    }
  }
  direction = "INGRESS"
}
