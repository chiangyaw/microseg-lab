# Microsegmentation Lab

These Terraform templates will deploy the infra for the hands-on lab in Azure.


## Prequisites:

1. Terraform v1.0 and above


## Deployment
1. Update the "terraform.tfvars" file with the necessary information.

2. Run "terraform init"

3. Run "terraform apply"

4. Infra will be deployed. It takes about 5-7 minutes for it to be ready.

5. The IPs of the VMs will be shown in the terraform outputs.

6. The kubeconfig file will be saved in the same directory.


## Removing The Demo Environment

1. Run "terraform destroy"