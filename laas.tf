variable "ssh_user" {
  type    = "string"
  default = "opnfv"
}
variable "ssh_host" {
  type = "string"
}

variable "inventory" {
  type = "string"
  default = "./hosts/hosts"
}

variable "playbook" {
  type = "string"
  default = "./lab_afterbooking/initial_setup.yml"
}

variable "ssh_key" {
  type = "string"
  default = "~/.ssh/id_rsa"
}

resource "null_resource" "laas" {
  connection {
    type        = "ssh"
    user        = "${var.ssh_user}"
    host        = "${var.ssh_host}"
    private_key = "${file("${var.ssh_key}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -qq update -y",
      "sudo apt -qq install python -y"
    ]
  }

  provisioner "local-exec" {
    command = "echo \"${var.ssh_host}\" > ${var.inventory}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${var.playbook} -e \"ssh_user=${var.ssh_user}\" -i ${var.inventory}"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}
