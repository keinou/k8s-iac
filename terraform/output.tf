resource "local_file" "AnsibleInventory" {
  content  = <<-EOT
[all:vars]
k3s_version=v1.27.4+k3s1
ansible_user=ubuntu
systemd_dir=/etc/systemd/system
master_ip="{{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }}"
extra_server_args="--tls-san {{ hostvars[groups['master'][0]]['ansible_host'] | default(groups['master'][0]) }} --disable=traefik --resolv-conf=/run/systemd/resolve/resolv.conf"
extra_agent_args="--resolv-conf=/run/systemd/resolve/resolv.conf"
ansible_ssh_private_key_file="terraform/oci.pem"
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[master]
${module.master.server.public_ip}

[node]
${module.worker1.server.public_ip}

[k3s_cluster:children]
master
node
EOT
  filename = "${path.module}/../ansible_inventory.ini"
}