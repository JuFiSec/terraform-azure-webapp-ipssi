output "vm_name" {
  description = "Nom de la machine virtuelle"
  value       = azurerm_linux_virtual_machine.web.name
}

output "vm_id" {
  description = "ID de la machine virtuelle"
  value       = azurerm_linux_virtual_machine.web.id
}

output "private_ip_address" {
  description = "Adresse IP privée de la VM"
  value       = azurerm_network_interface.web.private_ip_address
}

output "admin_username" {
  description = "Nom d'utilisateur administrateur"
  value       = azurerm_linux_virtual_machine.web.admin_username
}
