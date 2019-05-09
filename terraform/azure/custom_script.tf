data "template_file" "customscripttemplate" {
  template = "${file("${path.root}/${var.settingstemplatepath}")}"
}


resource "azurerm_virtual_machine_extension" "sawtoothinstall" {
  name                 = "sawtooth_install"
  location             = "${var.resource_group_location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  #virtual_machine_name = "${azurerm_virtual_machine.vmterraformsawtooth.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.vmterraformsawtooth.*, count.index)}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = "${data.template_file.customscripttemplate.rendered}"
}
