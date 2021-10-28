# Creating Storage Account for Boot Diagnostics for Serial Console access to VMs
resource "azurerm_storage_account" "diag-storage-account" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    project = "microsegmentation-lab"
  }

  depends_on = [random_id.randomId]
}