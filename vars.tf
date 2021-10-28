variable "resource_group_name" {}

variable "location" {}

variable "AllowedSourceIPRange" {}

variable "adminUsername" {}

variable "adminPassword" {}

variable "node_count" {}

variable "k8s_version" {}

variable "cluster_name" {
    default = "microseg-lab"
}

variable "vmSize" {
    default = "Standard_B1s"
}

variable "k8NodeSize" {
    default = "Standard_DS2_v2"
}

# dns_service_ip must be in the same subnet as the service_cidr
variable "service_cidr" {
    default = "10.8.0.0/16"
}

variable "dns_service_ip" {
    default = "10.8.0.10"
}

variable "folder_scripts" {
    type = string
    description = "The path to the scripts folder"
    default = "./scripts"
}

variable "dns_prefix" {
    default = "microseg-lab"
}
