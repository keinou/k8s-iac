resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "oci.pem"
  file_permission = "0600"
}

module "compartment" {
  source = "./compartment"
  providers = {
    oci = oci
  }

  compartment_name          = var.compartment_name
  compartment_description   = var.compartment_description

}

module "vcn-cluster-01" {
  source = "./network"
  depends_on = [module.compartment]
  providers = {
    oci = oci
  }

  network_name = "vcn-cluster-01"
  network_dns_label = "internal"

  compartment_id = module.compartment.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  cidr_blocks            = var.cidr_blocks
  ssh_managemnet_network = var.ssh_managemnet_network

  developers_ips = [
    "179.95.29.29/32", // Rafael
    "168.0.72.9/32",   // Bovinao
    "179.95.49.81/32",   // Lucas
    "177.104.10.146/32", // Bruno
    "204.216.164.244/32", // srv-tst-easy
    "187.0.7.139/32", //Oryx
    "187.181.254.41/32", // dev oryx
    "138.122.23.128/32" //renan
  ]
}

module "master" {
  source     = "./compute"
  depends_on = [
    module.vcn-cluster-01,
    module.compartment
  ]

  server_name         = "k3s_server_0"
  compartment_id      = module.compartment.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cluster_subnet_id   = module.vcn-cluster-01.cluster_subnet.id

  vm_ocpu        = 2
  vm_ram         = 8
  vm_private_ip  = cidrhost(var.cidr_blocks[0], 10)
  
  permit_nsg_id   = [
    module.vcn-cluster-01.permit_ssh.id,
    module.vcn-cluster-01.permit_kubeapi.id,
    module.vcn-cluster-01.permit_http.id,
    module.vcn-cluster-01.permit_https.id,
    module.vcn-cluster-01.permit_developers.id
  ]
  
  ssh_authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]

}

module "worker1" {
  source     = "./compute"
  depends_on = [
    module.vcn-cluster-01,
    module.compartment
  ]

  server_name         = "k3s_server_1"
  compartment_id      = module.compartment.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cluster_subnet_id   = module.vcn-cluster-01.cluster_subnet.id

  vm_ocpu        = 2
  vm_ram         = 8
  vm_private_ip  = cidrhost(var.cidr_blocks[0], 11)
  
  permit_nsg_id   = [
    module.vcn-cluster-01.permit_ssh.id,
    module.vcn-cluster-01.permit_kubeapi.id,
    module.vcn-cluster-01.permit_http.id,
    module.vcn-cluster-01.permit_https.id,
    module.vcn-cluster-01.permit_developers.id
  ]
  
  ssh_authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]

}

module "worker2" {
  source     = "./compute"
  depends_on = [
    module.vcn-cluster-01,
    module.compartment
  ]

  server_name         = "k3s_server_2"
  compartment_id      = module.compartment.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cluster_subnet_id   = module.vcn-cluster-01.cluster_subnet.id

  vm_ocpu        = 2
  vm_ram         = 8
  vm_private_ip  = cidrhost(var.cidr_blocks[0], 12)
  
  permit_nsg_id   = [
    module.vcn-cluster-01.permit_ssh.id,
    module.vcn-cluster-01.permit_kubeapi.id,
    module.vcn-cluster-01.permit_http.id,
    module.vcn-cluster-01.permit_https.id,
    module.vcn-cluster-01.permit_developers.id
  ]
  
  ssh_authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]

}

resource "oci_load_balancer_load_balancer" "cluster_load_balance" {
    #Required
    compartment_id = module.compartment.compartment_id
    display_name = "cluster_nlb"
    shape = "flexible"
    subnet_ids = [
      module.vcn-cluster-01.cluster_subnet.id
    ]

    shape_details {
        #Required
        maximum_bandwidth_in_mbps = "10"
        minimum_bandwidth_in_mbps = "10"
    }
}

resource "oci_load_balancer_backend_set" "default_backend_set" {
    load_balancer_id = oci_load_balancer_load_balancer.cluster_load_balance.id
    name = "default_backend"
    policy = "LEAST_CONNECTIONS"
    health_checker {
        protocol = "TCP"
        port = 80
    }
}

resource "oci_load_balancer_backend" "master_backend" {
    #Required
    backendset_name = oci_load_balancer_backend_set.default_backend_set.name
    ip_address = module.master.server.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.cluster_load_balance.id
    port = 80
}

resource "oci_load_balancer_backend" "worker1_backend" {
    #Required
    backendset_name = oci_load_balancer_backend_set.default_backend_set.name
    ip_address = module.worker1.server.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.cluster_load_balance.id
    port = 80
}

resource "oci_load_balancer_backend" "worker2_backend" {
    #Required
    backendset_name = oci_load_balancer_backend_set.default_backend_set.name
    ip_address = module.worker2.server.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.cluster_load_balance.id
    port = 80
}