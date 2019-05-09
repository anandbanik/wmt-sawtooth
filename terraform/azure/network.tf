# Create a vnet in the above resource group
resource "azurerm_virtual_network" "vnetterraformsawtooth" {
    name                = "vnet-terraform-sawtooth"
    address_space       = ["${var.vnet_address_space}"]
    location            = "${var.resource_group_location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"


    tags {
        environment = "Razorback Sawtooth"
    }
}


# Create subnet in the above vnet
resource "azurerm_subnet" "appsubnet" {
    name                 = "app-subnet-terraform-sawtooth"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnetterraformsawtooth.name}"
    address_prefix       = "${var.subnet_address_space}"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsgappterraformsawtooth" {
    name                = "nsg-app-razorback-sawtooth"
    location            = "${var.resource_group_location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "${var.ssh_ips}"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Sawtooth_Validator"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8800"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Sawtooth_REST"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8008"
        source_address_prefix      = "${var.rest_ips}"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Sawtooth_ELK"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Sawtooth-Validator"
        priority                   = 2002
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8800"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Sawtooth-REST"
        priority                   = 2003
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8008"
        source_address_prefix      = "${var.rest_ips}"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Sawtooth-ELK"
        priority                   = 2004
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "${var.logs_ips}"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Razorback Sawtooth"
    }
}

resource "azurerm_subnet_network_security_group_association" "subnetnsgasscoationsawtooth" {
    subnet_id                     = "${azurerm_subnet.appsubnet.id}"
    network_security_group_id     = "${azurerm_network_security_group.nsgappterraformsawtooth.id}"
}