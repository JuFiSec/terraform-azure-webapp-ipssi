output "mysql_server_name" {
  description = "Nom du serveur MySQL"
  value       = azurerm_mysql_flexible_server.main.name
}

output "mysql_server_fqdn" {
  description = "FQDN du serveur MySQL"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_database_name" {
  description = "Nom de la base de données"
  value       = azurerm_mysql_flexible_database.webapp.name
}

output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = azurerm_storage_account.webapp.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Endpoint principal du stockage blob"
  value       = azurerm_storage_account.webapp.primary_blob_endpoint
}
