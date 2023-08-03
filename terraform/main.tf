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