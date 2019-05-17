output "Public IPs" {
    value = ["${azurerm_public_ip.pubipterraformsawtooth.*.ip_address}"]
}