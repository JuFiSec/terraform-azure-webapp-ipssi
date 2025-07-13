output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Localisation du groupe de ressources"
  value       = azurerm_resource_group.main.location
}

output "vnet_name" {
  description = "Nom du réseau virtuel"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID du réseau virtuel"
  value       = azurerm_virtual_network.main.id
}

output "web_subnet_id" {
  description = "ID du sous-réseau web"
  value       = azurerm_subnet.web.id
}

output "database_subnet_id" {
  description = "ID du sous-réseau base de données"
  value       = azurerm_subnet.database.id
}

output "public_ip_id" {
  description = "ID de l'IP publique"
  value       = azurerm_public_ip.web.id
}

output "public_ip_address" {
  description = "Adresse IP publique"
  value       = azurerm_public_ip.web.ip_address
}

output "web_nsg_id" {
  description = "ID du groupe de sécurité réseau web"
  value       = azurerm_network_security_group.web.id
}
