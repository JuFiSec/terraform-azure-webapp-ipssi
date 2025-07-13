# outputs.tf
# Sorties principales du projet
# Informations importantes pour l'équipe IPSSI

output "resource_group_name" {
  description = "Nom du groupe de ressources créé"
  value       = module.network.resource_group_name
}

output "public_ip_address" {
  description = "Adresse IP publique du serveur web"
  value       = module.network.public_ip_address
}

output "website_url" {
  description = "URL complète du site web"
  value       = "http://${module.network.public_ip_address}"
}

output "vm_name" {
  description = "Nom de la machine virtuelle"
  value       = module.compute.vm_name
}

output "mysql_server_name" {
  description = "Nom du serveur MySQL"
  value       = module.database.mysql_server_name
}

output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = module.database.storage_account_name
}

output "ssh_connection_command" {
  description = "Commande pour se connecter en SSH"
  value       = "ssh ${var.admin_username}@${module.network.public_ip_address}"
}

output "project_summary" {
  description = "Résumé du projet"
  value = {
    project_name   = var.project_name
    environment    = var.environment
    location       = var.location
    team_lead      = "FIENI DANNIE INNOCENT JUNIOR"
    network_admin  = "Kaouthar Brazi"
    database_admin = "Amine Karassane"
    school         = "IPSSI Nice"
    program        = "M1 Cybersécurité & Cloud Computing"
  }
}