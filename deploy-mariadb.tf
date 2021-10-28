# Create Interface for MariaDB VM
resource "azurerm_network_interface" "mariadb_eth0" {
  name                = "mariadb-eth0"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = azurerm_subnet.mariadb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.20.10"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.mariadb
  ]
}

# Create MariaDB VM
resource "azurerm_linux_virtual_machine" "mariadb" {
  name                = "mariadb"
  computer_name       = "mariadb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vmSize

  disable_password_authentication = false
  admin_username      = var.adminUsername
  admin_password      = var.adminPassword

  network_interface_ids = [azurerm_network_interface.mariadb_eth0.id]

  os_disk {
    name                   = "mariadb-osdisk1"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag-storage-account.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(local.user_data_mariadb)

  tags = {
    RunStatus       = "NOSTOP"
    StoreStatus     = "DND"
    application     = "wordpress"
    role            = "backend"
    project         = "microsegmentation-lab"
    enforcer        = "yes"
  }

  depends_on = [
    azurerm_network_interface.mariadb_eth0,
    azurerm_storage_account.diag-storage-account
  ]
}
