variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "cluster_subnet_id" {
  description = "Subnet for the bastion instance"
  type        = string
}

variable "permit_ssh_nsg_id" {
  description = "NSG to permit SSH"
  type        = string
}

variable "permit_kubeapi_nsg_id" {
  description = "NSG to permit KubeAPI"
  type        = string
}

variable "ssh_authorized_keys" {
  description = "List of authorized SSH keys"
  type        = list(any)
}


variable "cidr_blocks" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}

variable "image_ocdi" {
  description = "OCDI of image"
  type = string
  default = "ocid1.image.oc1.sa-vinhedo-1.aaaaaaaaw7vepgkop22hfepvnz7mzbn27lyhi5mt7pnabyo4uoorjbadvgpq"
}

variable "availability_domain" {
  description = "Availability Domain"
  type = string
  default = "MWFL:SA-VINHEDO-1-AD-1"
}

locals {
  ampere_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = 1
    ram      = 3

    source_id   = var.image_ocdi
    source_type = "image"

    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
  micro_instance_config = {
    shape_id = "VM.Standard.E2.1.Micro"
    ocpus    = 1
    ram      = 1

    source_id   = var.image_ocdi
    source_type = "image"

    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
}