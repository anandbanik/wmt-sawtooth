# Terraform Script for provisioning Ubuntu with Sawtooth installed

## Steps

1. Create a file called "terraform.tfvars" and make sure it has "subscription_id", "client_id", "client_secret", ,"tenant_id".
   Also add your public key to access the VM
   For the rest, you can use the default values in "variables.tf"

2. Initiate the terraform script with the below command
    ```bash
    terraform init
    ```
3. Create a plan for terraform execution with the below command
    ```bash
    terraform plan
    ```
4. Review the above plan and if looks good, go ahead and execute the script.
    ```bash
    terraform apply
    ```
