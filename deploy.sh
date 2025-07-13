#!/bin/bash
# deploy-simple.sh - Version simplifiée et corrigée
# TP Terraform IPSSI - Équipe FIENI DANNIE

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
START_TIME=$(date +%s)
LOG_FILE="deployment-$(date +%Y%m%d-%H%M%S).log"

# Fonctions utilitaires
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_step() {
    echo ""
    echo -e "${BLUE}🔄 $1${NC}"
    echo "----------------------------------------"
    log "ÉTAPE: $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    log "SUCCÈS: $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
    log "ATTENTION: $1"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    log "ERREUR: $1"
    exit 1
}

print_header() {
    clear
    echo -e "${BLUE}"
    echo "=========================================="
    echo "    DÉPLOIEMENT TERRAFORM IPSSI"
    echo "=========================================="
    echo "Chef: Fieni Dannie"
    echo "Réseau: Kaouthar Brazi"
    echo "Database: Amine Karassane"
    echo "École: IPSSI Nice - M1 Cybersécurité"
    echo "=========================================="
    echo -e "${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    print_step "Vérification des prérequis"
    
    # Terraform
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform n'est pas installé"
    fi
    
    # Azure CLI
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI n'est pas installé"
    fi
    
    # Connexion Azure
    if ! az account show &> /dev/null; then
        print_warning "Connexion Azure requise"
        az login
    fi
    
    # Fichier terraform.tfvars
    if [[ ! -f "terraform.tfvars" ]]; then
        print_error "Fichier terraform.tfvars non trouvé"
    fi
    
    # Clé SSH
    if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
        print_warning "Génération de la clé SSH..."
        ssh-keygen -t rsa -b 4096 -C "fieni.dannie@ipssi.fr" -f ~/.ssh/id_rsa -N ""
        print_success "Clé SSH générée"
    fi
    
    print_success "Prérequis vérifiés"
}

# Configuration
show_configuration() {
    print_step "Configuration du déploiement"
    
    echo -e "${YELLOW}Configuration:${NC}"
    echo "• Région: France Central"
    echo "• VM: Standard_B2s"
    echo "• Admin: adminuser"
    echo "• SSH: ~/.ssh/id_rsa.pub"
    
    echo -e "${BLUE}Compte Azure:${NC}"
    az account show --query "{subscriptionId:id, name:name}" -o table
}

# Validation Terraform
validate_terraform() {
    print_step "Validation Terraform"
    
    echo "📐 Formatage..."
    terraform fmt -recursive
    
    echo "✅ Validation..."
    if terraform validate; then
        print_success "Configuration valide"
    else
        print_error "Erreurs de validation"
    fi
}

# Initialisation
init_terraform() {
    print_step "Initialisation Terraform"
    
    if [[ -f ".terraform.lock.hcl" ]]; then
        read -p "Réinitialiser Terraform ? (y/N): " reset_confirm
        if [[ $reset_confirm =~ ^[Yy]$ ]]; then
            rm -rf .terraform .terraform.lock.hcl
            print_success "État réinitialisé"
        fi
    fi
    
    if terraform init; then
        print_success "Terraform initialisé"
    else
        print_error "Échec initialisation"
    fi
}

# Planification
plan_deployment() {
    print_step "Planification"
    
    if terraform plan -out=tfplan -var-file="terraform.tfvars"; then
        print_success "Plan généré"
        
        echo -e "${BLUE}Résumé:${NC}"
        terraform show tfplan | grep -E "(Plan:|will be created)" | head -5
    else
        print_error "Échec planification"
    fi
}

# Déploiement
deploy_infrastructure() {
    print_step "Déploiement Infrastructure"
    
    echo -e "${YELLOW}⚠️ ATTENTION:${NC}"
    echo "• Ressources payantes sur Azure"
    echo "• Coût estimé: ~50€/mois"
    echo "• Région: France Central"
    echo "• Durée: 10-15 minutes"
    
    read -p "Confirmer le déploiement ? (y/N): " deploy_confirm
    
    if [[ $deploy_confirm =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}🚀 Déploiement en cours...${NC}"
        
        if terraform apply tfplan | tee -a "$LOG_FILE"; then
            print_success "Infrastructure déployée"
            return 0
        else
            print_error "Échec déploiement"
        fi
    else
        print_warning "Déploiement annulé"
        return 1
    fi
}

# Vérifications post-déploiement
post_deployment_check() {
    print_step "Vérifications post-déploiement"
    
    if terraform output > /dev/null 2>&1; then
        PUBLIC_IP=$(terraform output -raw public_ip_address 2>/dev/null || echo "N/A")
        WEBSITE_URL=$(terraform output -raw website_url 2>/dev/null || echo "N/A")
        
        echo -e "${GREEN}🎉 Déploiement réussi !${NC}"
        echo ""
        echo -e "${BLUE}Informations:${NC}"
        echo "• Site web: $WEBSITE_URL"
        echo "• IP publique: $PUBLIC_IP"
        
        # Test rapide
        if [[ "$PUBLIC_IP" != "N/A" ]]; then
            if ping -c 2 "$PUBLIC_IP" > /dev/null 2>&1; then
                print_success "Test réseau OK"
            else
                print_warning "Test réseau échoué (normal si ICMP filtré)"
            fi
        fi
        
        return 0
    else
        print_error "Impossible de récupérer les informations"
    fi
}

# Rapport simple
generate_simple_report() {
    print_step "Génération du rapport"
    
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    local report_file="deployment-report-$(date +%Y%m%d-%H%M%S).txt"
    
    cat > "$report_file" << EOL
RAPPORT DE DÉPLOIEMENT - TP TERRAFORM IPSSI
==========================================

Date: $(date)
Durée: ${minutes}m ${seconds}s
Équipe: FIENI DANNIE (Chef), Kaouthar Brazi (Réseau), Amine Karassane (BDD)
École: IPSSI Nice - M1 Cybersécurité & Cloud Computing

RÉSUMÉ:
- Status: Déployé avec succès
- Infrastructure: Azure France Central
- Site web: $(terraform output -raw website_url 2>/dev/null || echo "N/A")
- IP publique: $(terraform output -raw public_ip_address 2>/dev/null || echo "N/A")

ARCHITECTURE:
- VM: Ubuntu 22.04 + Apache + PHP
- Base de données: MySQL Flexible Server
- Réseau: VNet sécurisé
- Stockage: Azure Storage Account

RAPPEL:
N'oubliez pas: terraform destroy (pour éviter les frais)

Rapport généré le $(date)
EOL

    print_success "Rapport généré: $report_file"
}

# Instructions finales
show_final_instructions() {
    echo ""
    echo -e "${BLUE}=========================================="
    echo "         DÉPLOIEMENT TERMINÉ !"
    echo "==========================================${NC}"
    
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    echo -e "${GREEN}✅ Succès en ${minutes}m ${seconds}s${NC}"
    
    echo -e "${YELLOW}⚠️ Important:${NC}"
    echo "terraform destroy  # Supprimer les ressources"
    
    echo -e "${BLUE}Fichiers générés:${NC}"
    echo "• $LOG_FILE"
    echo "• tfplan"
    if ls deployment-report-*.txt > /dev/null 2>&1; then
        echo "• $(ls deployment-report-*.txt | tail -1)"
    fi
}

# Fonction principale
main() {
    print_header
    
    echo -e "${YELLOW}🎯 Déploiement automatique TP Terraform IPSSI${NC}"
    echo "Ce script va déployer une infrastructure web sur Azure"
    echo ""
    
    check_prerequisites
    show_configuration
    validate_terraform
    init_terraform
    plan_deployment
    
    if deploy_infrastructure; then
        if post_deployment_check; then
            generate_simple_report
            show_final_instructions
        fi
    else
        echo -e "${YELLOW}💡 Déploiement annulé ou échoué${NC}"
        echo "📝 Consultez les logs: $LOG_FILE"
    fi
}

# Gestion des interruptions
trap 'echo -e "\n${YELLOW}🛑 Interrompu par utilisateur${NC}"; exit 1' INT TERM

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi