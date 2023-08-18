output "vcn" {
  description = "Created VCN"
  value       = oci_core_vcn.cluster_network
}

output "cluster_subnet" {
  description = "Subnet of the k3s cluser"
  value       = oci_core_subnet.cluster_subnet
  depends_on  = [oci_core_subnet.cluster_subnet]
}

output "permit_ssh" {
  description = "NSG to permit ssh"
  value       = oci_core_network_security_group.permit_ssh
}

output "permit_kubeapi" {
  description = "NSG to permit KubeAPI"
  value       = oci_core_network_security_group.permit_kubeapi
}

output "permit_http" {
  description = "NSG to permit HTTP"
  value       = oci_core_network_security_group.permit_http
}

output "permit_https" {
  description = "NSG to permit HTTPS"
  value       = oci_core_network_security_group.permit_https
}

output "ad" {
  value = data.oci_identity_availability_domain.ad.name
}