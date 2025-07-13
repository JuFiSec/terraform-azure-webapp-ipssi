# database/main.tf
# Responsable : Amine Karassane - Équipe Base de Données
# VERSION CORRIGÉE pour les erreurs de déploiement

resource "random_string" "db_suffix" {
  length  = 4
  upper   = false
  special = false
  numeric = true
  lower   = true
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "${var.project_name}.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
  tags                  = var.common_tags
}

resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${var.project_name}-${random_string.db_suffix.result}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  backup_retention_days  = 7
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  storage {
    size_gb = 20
    iops    = 360
  }

  delegated_subnet_id = var.database_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
  tags       = var.common_tags
}

resource "azurerm_mysql_flexible_database" "webapp" {
  name                = "webapp_db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_storage_account" "webapp" {
  name                     = "stwebapp${random_string.db_suffix.result}" # CORRIGÉ: Nom simplifié
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.common_tags
}

resource "azurerm_storage_container" "webapp_files" {
  name                  = "webapp-files"
  storage_account_name  = azurerm_storage_account.webapp.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.webapp.name
  container_access_type = "private"
}