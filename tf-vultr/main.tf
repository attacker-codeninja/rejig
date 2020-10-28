resource "vultr_server" "strike" {
    plan_id = "203"
    region_id = "1"
    os_id = "387"
    tag = "atk"
    hostname = var.strike_img_name
    label = var.strike_img_name
    enable_ipv6 = true
    auto_backup = false
    ssh_key_ids = var.vultr_ssh_key_id
    count = 1

    provisioner "remote-exec" {
  
        inline = ["apt update && apt install python -y"]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file(var.vultr_key_path)}"
            host = self.main_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -u root -i '${self.main_ip}', --private-key ${var.vultr_key_path} ../ansible/playbook-bun2atk.yml --vault-password-file ${var.my_vualt_file}"
    }
}

output "Strike_PublicIP" {
    value = vultr_server.strike[*].main_ip
}

resource "vultr_server" "proxy" {
    plan_id = "201"
    region_id = "1"
    os_id = "387"
    tag = "proxy"
    hostname = var.proxy_img_name
    label = var.proxy_img_name
    enable_ipv6 = true
    auto_backup = false
    ssh_key_ids = var.vultr_ssh_key_id
    count = 0

    provisioner "remote-exec" {
  
        inline = ["apt update && apt install python -y"]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file(var.vultr_key_path)}"
            host = self.main_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -u root -i '${self.main_ip}', --private-key ${var.vultr_key_path} ../ansible/playbook-foundation.yml --vault-password-file ${var.my_vualt_file}"
    }
}

output "Proxy_PublicIP" {
    value = vultr_server.proxy[*].main_ip
}
