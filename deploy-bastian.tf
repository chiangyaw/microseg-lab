# Create Public IP Addresses for Bastian Host
resource "azurerm_public_ip" "bastian_pip" {
  name                    = "bastian_pip-${random_id.randomId.hex}"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
  sku                     = "Standard"
}

# Create Interface for Bastian Host
resource "azurerm_network_interface" "bastian_eth0" {
  name                = "bastian-eth0"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "eth0"
    subnet_id                     = azurerm_subnet.bastian.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.30.10"
    public_ip_address_id          = azurerm_public_ip.bastian_pip.id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.bastian
  ]
}

# Create Bastian Host VM
resource "azurerm_linux_virtual_machine" "bastian" {
  name                = "bastian"
  computer_name       = "bastian"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vmSize

  disable_password_authentication = false
  admin_username      = var.adminUsername
  admin_password      = var.adminPassword
  
#  admin_ssh_key {
#    username   = var.adminUsername
#    public_key = file(var.ssh_public_key)
#  }

  network_interface_ids = [azurerm_network_interface.bastian_eth0.id]

  os_disk {
    name                   = "bastian-osdisk1"
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

  custom_data = base64encode(local.user_data_bastian)

  tags = {
    RunStatus       = "NOSTOP"
    StoreStatus     = "DND"
    role            = "bastian_host"
    project         = "microsegmentation-lab"
  }

  # Connect to the Bastion instance via Terraform and remotely executes the install script using SSH
  provisioner "file" {
    source      = "${var.folder_scripts}/k8s.sh"
    destination = "/tmp/k8s.sh"
  }

  provisioner "file" {
    source      = "${var.folder_scripts}/k8s-get-pods.sh"
    destination = "/tmp/k8s.sh"
  }

  provisioner "file" {
    source      = "${var.folder_scripts}/k8s-get-services.sh"
    destination = "/tmp/k8s.sh"
  }
  
  provisioner "file" {
    source      = "${var.folder_scripts}/guestbook.yaml"
    destination = "/tmp/guestbook.yaml"
  }
  
  provisioner "file" {
    source      = "${var.folder_scripts}/sock-shop.yaml"
    destination = "/tmp/sock-shop.yaml"
  }
  
  provisioner "file" {
    source      = "${var.folder_scripts}/rogue.yaml"
    destination = "/tmp/rogue.yaml"
  }
  
  provisioner "file" {
    source      = "${var.folder_scripts}/victim.yaml"
    destination = "/tmp/victim.yaml"
  }

  provisioner "file" {
    source      = "kubeconfig"
    destination = "/home/${var.adminUsername}/kubeconfig"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/k8s*.sh"
    ]
  }

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.bastian_pip.ip_address
    user     = var.adminUsername
    password = var.adminPassword
    # private_key = file(var.private_key_path)
  }

  depends_on = [
    azurerm_network_interface.bastian_eth0,
    azurerm_storage_account.diag-storage-account,
    local_file.kubeconfig
  ]
}
