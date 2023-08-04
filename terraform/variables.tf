locals {
  cidr_blocks            = ["10.0.0.0/24"]
  ssh_managemnet_network = "1.1.1.1/32"
}

variable "fingerprint" {
  description = "The fingerprint of the key to use for signing"
  type        = string
}

variable "private_key" {
  description = "Private key to use for signing"
  type        = string
}

variable "region" {
  description = "The region to connect to."
  type        = string
  default     = "sa-vinhedo-1"
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "The user OCID."
  type        = string
}

variable "compartment_name" {
  description = "Name of OCI Compartment"
  type        = string
}

variable "compartment_description" {
  description = "Description of OCI Compartment"
  type        = string
}

variable "cidr_blocks" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}