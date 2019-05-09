# Create a public IP for the Ubuntu Instance
resource "azurerm_public_ip" "pubipterraformsawtooth" {
    name                         = "pub-ip-razorback-sawtooth-node${count.index+1}"
    location                     = "${var.resource_group_location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    allocation_method            = "Static"
    count                        = "${var.vm_count}"

    tags {
        environment = "Razorback Sawtooth"
    }
}

# Create network interface
resource "azurerm_network_interface" "nicvmterraformsawtooth" {
    name                      = "nic-vm-razorback-sawtooth-node${count.index+1}"
    count                     = "${var.vm_count}"
    location                  = "${var.resource_group_location}"
    resource_group_name       = "${azurerm_resource_group.rg.name}"

    ip_configuration {
        name                          = "vmNicConfiguration"
        subnet_id                     = "${azurerm_subnet.appsubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${element(azurerm_public_ip.pubipterraformsawtooth.*.id, count.index)}"
    }

    tags {
        environment = "Razorback Sawtooth"
    }
}


# Create virtual machine node
resource "azurerm_virtual_machine" "vmterraformsawtooth" {    
    name                  = "vm-sawtooth-razorback-node${count.index+1}"
    count                 = "${var.vm_count}"
    location              = "${var.resource_group_location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    #network_interface_ids = ["${azurerm_network_interface.nicvmterraformsawtooth.id}"]
    network_interface_ids = ["${element(azurerm_network_interface.nicvmterraformsawtooth.*.id, count.index)}"]
    vm_size               = "${var.vm_instance_type}" 

    
    storage_os_disk {
        name              = "razorbackSawtoothDiskNode${count.index+1}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }
    

    
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }
    
    os_profile {
        computer_name  = "${var.computer_name}-node${count.index+1}"
        admin_username = "${var.admin_username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${var.public_key_data}"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.storageaccounttfsawtooth.primary_blob_endpoint}"
    }

    tags {
        environment = "Razorback Sawtooth"
    }
}

