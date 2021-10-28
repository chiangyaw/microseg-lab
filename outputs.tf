output "MariaDB_Private_IP" {
    value = azurerm_linux_virtual_machine.mariadb.private_ip_address
}

output "Wordpress_Private_IP" {
    value = azurerm_linux_virtual_machine.wordpress.private_ip_address
}

output "Wordpress_Public_IP" {
    value = azurerm_linux_virtual_machine.wordpress.public_ip_address
}

output "Bastian_Host_Public_IP" {
    value = azurerm_linux_virtual_machine.bastian.public_ip_address
}
