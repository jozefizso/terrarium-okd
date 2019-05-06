provider "esxi" {
  esxi_hostname = "${var.esxi_server}"
  esxi_username = "${var.esxi_user}"
  esxi_password = "${var.esxi_password}"
}

# ESXi server requirements:
# networks
#  - public_network (vSwitch0) # - use this network to connect VMs to
#  - Management Network (vSwitch0)
# 
# data stores
#  - datastore1
#
# Virtual Hardware Versions
# 16 - Workstation Pro 15.x
# 14 - ESXi 6.7 (Workstation Pro 14.x)
# 13 - ESXi 6.5

resource "esxi_guest" "centos01" {
  guest_name = "centos01"
  disk_store = "datastore1"
  notes = "Terraform virtual machine."

  memsize = 1024 # MB
  numvcpus = 2

  virthwver = 14
  power = "off"
  guest_startup_timeout = 10

  network_interfaces = [
    {
      virtual_network = "public_network"
    },
  ]
}
