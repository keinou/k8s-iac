output "cluster_token" {
  value = random_string.cluster_token.result
}

resource "local_file" "AnsibleInventory" {
  content  = <<-EOT
[all:vars]
k3s_version=v1.22.3+k3s1
ansible_user=ubuntu
systemd_dir=/etc/systemd/system
master_ip="{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
extra_server_args="--tls-san {{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
extra_agent_args=""
ansible_ssh_private_key_file="terraform/oci.pem"
ansible_user=ubuntu

[master]
${oci_core_instance.server_0.public_ip}

[node]
${oci_core_instance.server_1.public_ip}

[k3s_cluster:children]
master
node
EOT
  filename = "${path.module}/../../ansible_inventory.ini"
}
