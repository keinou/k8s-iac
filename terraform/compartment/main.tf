resource "oci_identity_compartment" "_" {
  name          = var.compartment_name
  description   = var.compartment_description
  enable_delete = true
}