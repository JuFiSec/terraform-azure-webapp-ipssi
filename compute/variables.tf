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

variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
}

variable "admin_username" {
  description = "Nom d'utilisateur administrateur"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH"
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau"
  type        = string
}

variable "public_ip_id" {
  description = "ID de l'IP publique"
  type        = string
}

variable "mysql_server_fqdn" {
  description = "FQDN du serveur MySQL"
  type        = string
  default     = ""
}

variable "mysql_database_name" {
  description = "Nom de la base de données MySQL"
  type        = string
  default     = "webapp_db"
}

variable "common_tags" {
  description = "Tags communs"
  type        = map(string)
}
