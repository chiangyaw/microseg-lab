resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    dns_prefix          = "${var.dns_prefix}-${random_id.randomId.hex}"

    default_node_pool {
      # default_node_pool name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9.
      name               = "prismacloud"
      node_count         = var.node_count
      vm_size            = var.k8NodeSize
      type               = "VirtualMachineScaleSets"
      os_disk_size_gb    = 40
      os_disk_type       = "Managed"
      availability_zones = ["1", "2", "3"]

      tags = {
        RunStatus       = "NOSTOP"
        StoreStatus     = "DND"
        project         = "microsegmentation-lab"
        role            = "KubeNodes"
      }
    }

    identity {
      type = "SystemAssigned"
    }

    kubernetes_version = var.k8s_version

    network_profile {
      network_plugin     = "azure"
      load_balancer_sku  = "standard"
      outbound_type      = "loadBalancer"
      service_cidr       = var.service_cidr
      dns_service_ip     = var.dns_service_ip
      docker_bridge_cidr = "172.17.0.1/16"
    }

    role_based_access_control {
      enabled = true
    }

    tags = {
        RunStatus       = "NOSTOP"
        StoreStatus     = "DND"
        project         = "microsegmentation-lab"
    }
}

# Download kubeconfig file
resource "local_file" "kubeconfig" {
    content          = azurerm_kubernetes_cluster.k8s.kube_config_raw
    filename         = "kubeconfig"
    file_permission  = "0444"

     depends_on = [ azurerm_kubernetes_cluster.k8s ]
}
