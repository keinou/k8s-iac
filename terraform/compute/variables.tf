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

variable "permit_nsg_id" {
  description = "NSG to permit SSH"
  type        = list(string)
}

variable "ssh_authorized_keys" {
  description = "List of authorized SSH keys"
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

variable "server_name" {
  description = "Display name and hostname of server"
  type = string
}

variable "vm_ocpu" {
  description = "OCPUs for VM"
  type = number
  default = 1
}

variable "vm_ram" {
  description = "Memomy RAM for VM"
  type = number
  default = 2
}

variable "vm_private_ip" {
  description = "Privete IP of instance"
  type = string
}

locals {
  ampere_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = var.vm_ocpu
    ram      = var.vm_ram

    source_id   = var.image_ocdi
    source_type = "image"

    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
}