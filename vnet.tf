
# Create a virtual network
resource "azurerm_virtual_network" "network" {
  name                = "Microsegmentation-VNET"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    project = "microsegmentation-lab"
  }

  depends_on = [azurerm_resource_group.main]
}


#Create Wordpress subnet
resource "azurerm_subnet" "wordpress" {
    name                      = "wordpress-subnet"
    resource_group_name       = azurerm_resource_group.main.name
    address_prefixes          = ["10.10.10.0/24"]
    virtual_network_name      = azurerm_virtual_network.network.name

    depends_on = [azurerm_virtual_network.network]
}

resource "azurerm_subnet_network_security_group_association" "wordpress" {
  subnet_id                 = azurerm_subnet.wordpress.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}


#Create MariaDB subnet
resource "azurerm_subnet" "mariadb" {
    name                      = "mariadb-subnet"
    resource_group_name       = azurerm_resource_group.main.name
    address_prefixes          = ["10.10.20.0/24"]
    virtual_network_name      = azurerm_virtual_network.network.name

    depends_on = [azurerm_virtual_network.network]
}

resource "azurerm_subnet_network_security_group_association" "mariadb" {
  subnet_id                 = azurerm_subnet.mariadb.id
  network_security_group_id = azurerm_network_security_group.allow_all.id
}


#Create Bastian subnet
resource "azurerm_subnet" "bastian" {
    name                      = "bastian-subnet"
    resource_group_name       = azurerm_resource_group.main.name
    address_prefixes          = ["10.10.30.0/24"]
    virtual_network_name      = azurerm_virtual_network.network.name

    depends_on = [azurerm_virtual_network.network]
}

resource "azurerm_subnet_network_security_group_association" "bastian" {
  subnet_id                 = azurerm_subnet.bastian.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

