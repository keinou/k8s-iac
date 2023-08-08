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

module "network" {
  source = "./network"
  depends_on = [module.compartment]
  providers = {
    oci = oci
  }

  compartment_id = module.compartment.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  cidr_blocks            = var.cidr_blocks
  ssh_managemnet_network = local.ssh_managemnet_network
}

module "compute" {
  source     = "./compute"
  depends_on = [
    module.network,
    module.compartment
  ]

  compartment_id      = module.compartment.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  cluster_subnet_id   = module.network.cluster_subnet.id
  
  permit_ssh_nsg_id   = module.network.permit_ssh.id
  permit_kubeapi_nsg_id = module.network.permit_kubeapi.id
  
  ssh_authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]

  cidr_blocks = var.cidr_blocks
}