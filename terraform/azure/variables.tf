variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
  default = "rg-terraform-sawtooth"
}


variable "subscription_id" {
  type        = "string"
  description = "Subscription ID for Azure"
}


variable "client_id" {
  type        = "string"
  description = "Client ID for Azure"
}


variable "client_secret" {
  type        = "string"
  description = "Client Secret for Azure"
}


variable "tenant_id" {
  type        = "string"
  description = "Tenent ID for Azure"
}

variable "resource_group_location" {
  type        = "string"
  description = "Location of the azure resource group."
  default = "westus"
}

variable "vnet_address_space" {
  type        = "string"
  description = "Address space for the VNet."
  default = "192.168.0.0/22"
}

variable "subnet_address_space" {
  type        = "string"
  description = "Address space for the Subnet."
  default = "192.168.0.0/24"
}

variable "computer_name" {
    type = "string"
    description = "Hostname of the compute name"
    default = "vm-sawtooth-razorback-demo"
}

variable "admin_username" {
    type = "string"
    description = "Admin username of the compute"
    default = "rbsawtoothuser"
}

variable "public_key_data" {
    type = "string"
    description = "Public key for SSH"
}

variable "settingstemplatepath" {
    type = "string"
    description = "Template file path"
    default = "bootstrap.json"
}

variable "vm_instance_type" {
  type = "string"
  description = "VM Size"
  default = "Standard_D2s_v3"
}

variable "storage_account_name" {
  type = "string"
  description = "Total number of VM's provisioned"
  default = "razorbacksawtoothstorage"
}

variable "ssh_ips" {
  type = "string"
  description = "Source and Destination IP's for SSH access"
  default = "*"
}

variable "logs_ips" {
  type = "string"
  description = "Filebeat ELK IP's"
  default = "*"
}


variable "rest_ips" {
  type = "string"
  description = "REST access IP's"
  default = "*"
}



variable "vm_count" {
  type = "string"
  description = "No. of VM's"
  default = "2"  
}
