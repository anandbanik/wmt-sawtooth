# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccounttfsawtooth" {
    name                        = "${var.storage_account_name}${random_id.storage.hex}"
    resource_group_name         = "${azurerm_resource_group.rg.name}"
    location                    = "${var.resource_group_location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "Razorback Sawtooth"
    }
}


# Create a random id to uniquely identifying storage
resource "random_id" "storage" {
  byte_length = 4
}