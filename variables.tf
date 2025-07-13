variable "location" {
  description = "Azure region pour le déploiement"
  type        = string
  default     = "France Central"
}

variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "webapp-ipssi"
}

variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Nom d'utilisateur administrateur pour la VM"
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "mysql_admin_username" {
  description = "Nom d'utilisateur administrateur MySQL"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "Mot de passe administrateur MySQL"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "webapp-ipssi"
    Team        = "M1-Cybersecurite-IPSSI"
    Chef        = "FIENI-DANNIE"
    Reseau      = "Kaouthar-Brazi"
    Database    = "Amine-Karassane"
    School      = "IPSSI-Nice"
  }
}
