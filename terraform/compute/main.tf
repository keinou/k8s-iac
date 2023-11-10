resource "oci_core_instance" "_" {
  compartment_id      = var.compartment_id
  display_name        = var.server_name
  availability_domain = var.availability_domain
  shape               = local.ampere_instance_config.shape_id
  source_details {
    source_id   = local.ampere_instance_config.source_id
    source_type = local.ampere_instance_config.source_type
    boot_volume_size_in_gbs = 100
  }
  shape_config {
    memory_in_gbs = local.ampere_instance_config.ram
    ocpus         = local.ampere_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = var.vm_private_ip
    nsg_ids    = var.permit_nsg_id
  }
  metadata = {
    "ssh_authorized_keys" = local.ampere_instance_config.metadata.ssh_authorized_keys
  }
}

# resource "oci_core_instance" "server_1" {
#   compartment_id      = var.compartment_id
#   display_name        = "k3s_server_1"
#   availability_domain = var.availability_domain
#   shape               = local.ampere_instance_config.shape_id
#   source_details {
#     source_id   = local.ampere_instance_config.source_id
#     source_type = local.ampere_instance_config.source_type
#   }
#   shape_config {
#     memory_in_gbs = local.ampere_instance_config.ram
#     ocpus         = local.ampere_instance_config.ocpus
#   }
#   create_vnic_details {
#     subnet_id  = var.cluster_subnet_id
#     private_ip = cidrhost(var.cidr_blocks[0], 11)
#     nsg_ids    = [
#       var.permit_ssh_nsg_id,
#       var.permit_kubeapi_nsg_id
#     ]
#   }
#   metadata = {
#     "ssh_authorized_keys" = local.ampere_instance_config.metadata.ssh_authorized_keys
#   }
# }
