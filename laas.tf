variable "ssh_user" {
  type    = "string"
  default = "opnfv"
}
variable "ssh_hosts" {
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
  count = "${length(split(",", var.ssh_hosts))}"
  connection {
    type        = "ssh"
    user        = "${var.ssh_user}"
    host        = "${element(split(",", var.ssh_hosts), count.index)}"
    private_key = "${file("${var.ssh_key}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -qq update -y",
      "sudo apt -qq install python -y"
    ]
  }

  provisioner "local-exec" {
    command = "echo \"\" > ${var.inventory} && echo \"${element(split(",", var.ssh_hosts), count.index)}\" >> ${var.inventory}"
    environment = {
      count = "${length(split(",", var.ssh_hosts))}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${var.playbook} -e \"ssh_user=${var.ssh_user}\" -i ${var.inventory}"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}
