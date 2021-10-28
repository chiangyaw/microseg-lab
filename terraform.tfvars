# The name of a new resource group
resource_group_name = "<resource-group-name>"

# The Azure location where the resources will be deployed
location = "<azure location>"

# The source ip range from where you will be accessing the lab
AllowedSourceIPRange = "0.0.0.0/0"

# The admin username and password to access the VMs
adminUsername = "paloalto"
adminPassword = "<password>"

# The number of nodes in the K8s cluster
node_count = 2

# run the following command to list the K8s versions available in a region
# az aks get-versions --location <region> --output table
k8s_version = "1.21.2"