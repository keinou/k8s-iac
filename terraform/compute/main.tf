resource "oci_core_instance" "server_0" {
  compartment_id      = var.compartment_id
  display_name        = "k3s_server_0"
  availability_domain = var.availability_domain
  shape               = local.ampere_instance_config.shape_id
  source_details {
    source_id   = local.ampere_instance_config.source_id
    source_type = local.ampere_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.ampere_instance_config.ram
    ocpus         = local.ampere_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks[0], 10)
    nsg_ids    = [
      var.permit_ssh_nsg_id,
      var.permit_kubeapi_nsg_id
    ]
  }
  metadata = {
    "ssh_authorized_keys" = local.ampere_instance_config.metadata.ssh_authorized_keys
  }
}

resource "oci_core_instance" "server_1" {
  compartment_id      = var.compartment_id
  display_name        = "k3s_server_1"
  availability_domain = var.availability_domain
  shape               = local.ampere_instance_config.shape_id
  source_details {
    source_id   = local.ampere_instance_config.source_id
    source_type = local.ampere_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.ampere_instance_config.ram
    ocpus         = local.ampere_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks[0], 11)
    nsg_ids    = [
      var.permit_ssh_nsg_id,
      var.permit_kubeapi_nsg_id
    ]
  }
  metadata = {
    "ssh_authorized_keys" = local.ampere_instance_config.metadata.ssh_authorized_keys
  }
  depends_on = [oci_core_instance.server_0]
}
