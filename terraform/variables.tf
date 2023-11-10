locals {
  cidr_blocks            = ["10.0.0.0/24"]
}

variable "ssh_managemnet_network" {
  description = "Network can connect via SSH"
  type        = list(string)
}

variable "k3s_version" {
  description = "Version of K3S"
  type        = string
  default     = "v1.27.4+k3s1"
}

variable "cert_manager_version" {
  description = "Version of Cert-Manager"
  type        = string
  default     = "v1.12.3"
}

variable "cloudflare_origin_ca_key" {
  description = "Origin CA Key of API"
  type        = string
}

variable "registry_username" {
  description = "Your username for ghcr.io registry"
  type        = string
}

variable "registry_password" {
  description = "Your personal token for ghcr.io registry"
  type        = string
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