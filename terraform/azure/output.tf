output "Public IPs" {
    value = "${element(azurerm_public_ip.pubipterraformsawtooth.*.ip_address, 0)}"
}