variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "mysql_admin_username" {
  description = "Nom d'utilisateur administrateur MySQL"
  type        = string
}

variable "mysql_admin_password" {
  description = "Mot de passe administrateur MySQL"
  type        = string
  sensitive   = true
}

variable "database_subnet_id" {
  description = "ID du sous-réseau de base de données"
  type        = string
}

variable "vnet_id" {
  description = "ID du réseau virtuel"
  type        = string
}

variable "common_tags" {
  description = "Tags communs"
  type        = map(string)
}
