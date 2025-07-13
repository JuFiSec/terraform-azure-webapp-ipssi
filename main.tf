# main.tf
# Fichier principal du projet Terraform
# TP Infrastructure Web Azure - M1 Cybersécurité IPSSI Nice

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Module Réseau - Responsable : Kaouthar Brazi
module "network" {
  source = "./network"

  location     = var.location
  environment  = var.environment
  project_name = var.project_name
  common_tags  = var.common_tags
}

# Module Base de données - Responsable : Amine Karassane
module "database" {
  source = "./database"

  location             = var.location
  resource_group_name  = module.network.resource_group_name
  project_name         = var.project_name
  mysql_admin_username = var.mysql_admin_username
  mysql_admin_password = var.mysql_admin_password
  database_subnet_id   = module.network.database_subnet_id
  vnet_id              = module.network.vnet_id
  common_tags          = var.common_tags

  depends_on = [module.network]
}

# Module Compute - Responsable : FIENI DANNIE INNOCENT JUNIOR
module "compute" {
  source = "./compute"

  location            = var.location
  resource_group_name = module.network.resource_group_name
  project_name        = var.project_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id           = module.network.web_subnet_id
  public_ip_id        = module.network.public_ip_id
  mysql_server_fqdn   = try(module.database.mysql_server_fqdn, "")
  mysql_database_name = try(module.database.mysql_database_name, "webapp_db")
  common_tags         = var.common_tags

  depends_on = [module.network, module.database]
}