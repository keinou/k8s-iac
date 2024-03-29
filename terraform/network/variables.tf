variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "cidr_blocks" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}

variable "ssh_managemnet_network" {
  description = "Subnet allowed to ssh to hosts"
  type        = list(string)
}

variable "network_name" {
  description = "Name of network"
  type = string
}

variable "network_dns_label" {
  type = string
}

variable "developers_ips" {
  type = list(string)
}