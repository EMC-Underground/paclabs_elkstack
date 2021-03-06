# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = "administrator@pac.lab"
  password       = "Password#1"
  vsphere_server = "10.4.44.11"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Create a folder
#resource "vsphere_folder" "frontend" {
#  datacenter = "Datacenter"
#  path = "support_services"
#}

# Create a virtual machine within the folder
resource "vsphere_virtual_machine" "elkstack" {
  name   = "elkstack"
  datacenter = "Datacenter"
  domain = "elkstack.pac.lab"
  dns_servers = ["10.253.140.73"]
  cluster = "cluster"

  #folder = "${vsphere_folder.frontend.path}"
  vcpu   = 2
  memory = 4096

  network_interface {
    label = "VM_6.0_DPortGroup"
  }

  disk {
    datastore = "prod_ds"
    template = "UbuntuTmpl"
    type = "thin"
  }

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
  }
  provisioner "file" {
    source = "docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
    
    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
}
  provisioner "file" {
    source = "elasticsearch.yml"
    destination = "/tmp/elasticsearch.yml"

    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
}
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "echo password | sudo -S /tmp/script.sh"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
  }
}
  output "manager_public_ip" {
    value = "${vsphere_virtual_machine.elkstack.network_interface.0.ipv4_address}"
  }


