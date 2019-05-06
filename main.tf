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

#########################################
#  cloud-init for vmware!
#  You must install it on your source VM before cloning it!
#    See https://github.com/akutz/cloud-init-vmware-guestinfo
#########################################


#
# Template for initial configuration bash script
#    template_file is a great way to pass variables to
#    cloud-init
data "template_file" "Default" {
  template = "${file("userdata.tmpl")}"
  vars = {
    HOSTNAME = "okd-master"
    HELLO    = "Hello World!"
  }
}

resource "esxi_guest" "okd-master" {
  guest_name = "okd-master"
  disk_store = "datastore1"
  notes = "OpenShift master machine."

  memsize = 4096 # MB
  numvcpus = 4

  virthwver = 14
  power = "on"
  guest_startup_timeout = 10

  clone_from_vm = "_centos-7.6.1810.03_template"

  network_interfaces = [
    {
      virtual_network = "public_network"
    },
  ]

  # cloudinit data for vm
  #
  # Troubleshoot cloud-init data:
  #  vmtoolsd --cmd "info-get guestinfo.userdata"
  guestinfo = {
    userdata.encoding = "gzip+base64"
    userdata = "${base64gzip(data.template_file.Default.rendered)}"
  }
}
