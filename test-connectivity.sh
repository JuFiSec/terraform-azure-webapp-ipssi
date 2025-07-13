#!/bin/bash
# test-connectivity.sh - Tests de connectivité complets pour l'infrastructure IPSSI
# Vérifie tous les aspects réseau et connectivité du déploiement

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables globales
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
TEST_RESULTS=()

# Fonction d'affichage header
print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                🧪 TESTS DE CONNECTIVITÉ IPSSI               ║"
    echo "║              Infrastructure Web Azure - Terraform           ║"
    echo "║                                                              ║"
    echo "║  Validation complète réseau et services déployés            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${PURPLE}👥 Équipe: FIENI Dannie (Chef), Kaouthar Brazi (Réseau), Amine Karassane (BDD)${NC}"
    echo -e "${PURPLE}🎓 Formation: M1 Cybersécurité & Cloud Computing - IPSSI Nice${NC}"
    echo -e "${PURPLE}📅 Date: $(date '+%d/%m/%Y à %H:%M')${NC}"
    echo ""
}

# Fonction de test avec rapport
run_test() {
    local test_name="$1"
    local test_command="$2"
    local is_critical="${3:-false}"
    local timeout="${4:-10}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -ne "${CYAN}🔍 $test_name...${NC} "
    
    # Exécution du test avec timeout
    if timeout $timeout bash -c "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        TEST_RESULTS+=("✅ $test_name: PASS")
        return 0
    else
        if [ "$is_critical" = "true" ]; then
            echo -e "${RED}❌ FAIL (CRITIQUE)${NC}"
            TEST_RESULTS+=("❌ $test_name: FAIL (CRITIQUE)")
        else
            echo -e "${YELLOW}⚠️ FAIL${NC}"
            TEST_RESULTS+=("⚠️ $test_name: FAIL")
        fi
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Fonction de test avec détails
run_detailed_test() {
    local test_name="$1"
    local test_command="$2"
    local success_message="$3"
    local error_message="$4"
    
    echo -e "${CYAN}🔍 Test: $test_name${NC}"
    echo "   Commande: $test_command"
    
    if eval "$test_command"; then
        echo -e "   ${GREEN}✅ Résultat: $success_message${NC}"
        return 0
    else
        echo -e "   ${RED}❌ Erreur: $error_message${NC}"
        return 1
    fi
    echo ""
}

# Vérification des prérequis
check_prerequisites() {
    echo -e "${YELLOW}📋 Vérification des prérequis...${NC}"
    echo ""
    
    run_test "Terraform installé" "command -v terraform" true
    run_test "Azure CLI installé" "command -v az" true
    run_test "Curl installé" "command -v curl" true
    run_test "Netcat installé" "command -v nc || command -v netcat" false
    run_test "Ping disponible" "command -v ping" true
    
    # Vérifier si l'infrastructure est déployée
    if ! terraform state list > /dev/null 2>&1; then
        echo -e "${RED}❌ Infrastructure non déployée. Lancez 'terraform apply' d'abord.${NC}"
        exit 1
    fi
    
    echo ""
}

# Récupération des informations Terraform
get_terraform_outputs() {
    echo -e "${YELLOW}📊 Récupération des informations d'infrastructure...${NC}"
    echo ""
    
    # Variables globales pour les tests
    PUBLIC_IP=$(terraform output -raw public_ip_address 2>/dev/null || echo "")
    WEBSITE_URL=$(terraform output -raw website_url 2>/dev/null || echo "")
    SSH_COMMAND=$(terraform output -raw ssh_connection_command 2>/dev/null || echo "")
    RESOURCE_GROUP=$(terraform output -raw resource_group_name 2>/dev/null || echo "")
    VM_NAME=$(terraform output -raw vm_name 2>/dev/null || echo "")
    MYSQL_SERVER=$(terraform output -raw mysql_server_name 2>/dev/null || echo "")
    STORAGE_ACCOUNT=$(terraform output -raw storage_account_name 2>/dev/null || echo "")
    
    echo -e "${BLUE}📋 Informations récupérées:${NC}"
    echo -e "   • IP Publique: ${GREEN}$PUBLIC_IP${NC}"
    echo -e "   • Site Web: ${GREEN}$WEBSITE_URL${NC}"
    echo -e "   • Groupe de ressources: ${GREEN}$RESOURCE_GROUP${NC}"
    echo -e "   • Machine virtuelle: ${GREEN}$VM_NAME${NC}"
    echo -e "   • Serveur MySQL: ${GREEN}$MYSQL_SERVER${NC}"
    
    if [ -z "$PUBLIC_IP" ] || [ -z "$WEBSITE_URL" ]; then
        echo -e "${RED}❌ Informations manquantes. Vérifiez le déploiement Terraform.${NC}"
        exit 1
    fi
    
    echo ""
}

# Tests de connectivité réseau de base
test_basic_connectivity() {
    echo -e "${YELLOW}🌐 SECTION 1: Tests de Connectivité Réseau${NC}"
    echo "================================================"
    echo ""
    
    # Test ping vers l'IP publique
    echo -e "${CYAN}🏓 Test de ping vers l'infrastructure...${NC}"
    run_detailed_test "Ping vers IP publique" \
        "ping -c 3 -W 5 $PUBLIC_IP" \
        "Serveur accessible via ping" \
        "Serveur non accessible ou filtre ICMP actif"
    
    # Test de résolution DNS (si applicable)
    if [[ $WEBSITE_URL =~ ^http://([^/]+) ]]; then
        HOSTNAME="${BASH_REMATCH[1]}"
        echo -e "${CYAN}🌍 Test de résolution DNS...${NC}"
        run_detailed_test "Résolution DNS" \
            "nslookup $HOSTNAME" \
            "DNS résolu correctement" \
            "Problème de résolution DNS"
    fi
    
    echo ""
}

# Tests des ports et services
test_ports_and_services() {
    echo -e "${YELLOW}🚪 SECTION 2: Tests des Ports et Services${NC}"
    echo "=============================================="
    echo ""
    
    echo -e "${CYAN}🔌 Test des ports critiques...${NC}"
    
    # Test port SSH (22)
    run_detailed_test "Port SSH (22)" \
        "nc -zv -w 5 $PUBLIC_IP 22" \
        "Port SSH ouvert et accessible" \
        "Port SSH fermé ou inaccessible"
    
    # Test port HTTP (80)
    run_detailed_test "Port HTTP (80)" \
        "nc -zv -w 5 $PUBLIC_IP 80" \
        "Port HTTP ouvert et accessible" \
        "Port HTTP fermé ou inaccessible"
    
    # Test port HTTPS (443) - optionnel
    run_detailed_test "Port HTTPS (443)" \
        "nc -zv -w 5 $PUBLIC_IP 443" \
        "Port HTTPS ouvert" \
        "Port HTTPS fermé (normal si pas configuré)"
    
    echo ""
    
    # Scan nmap si disponible
    if command -v nmap &> /dev/null; then
        echo -e "${CYAN}🔍 Scan Nmap des ports principaux...${NC}"
        echo "Résultats du scan:"
        nmap -p 22,80,443 $PUBLIC_IP | grep -E "(open|closed|filtered)" || echo "Aucun port détecté"
        echo ""
    fi
}

# Tests du serveur web
test_web_server() {
    echo -e "${YELLOW}🌐 SECTION 3: Tests du Serveur Web${NC}"
    echo "======================================="
    echo ""
    
    echo -e "${CYAN}🌍 Test de réponse HTTP...${NC}"
    
    # Test de base HTTP
    run_detailed_test "Réponse HTTP 200" \
        "curl -s -o /dev/null -w '%{http_code}' $WEBSITE_URL | grep -q '200'" \
        "Serveur web répond correctement (HTTP 200)" \
        "Serveur web ne répond pas ou erreur HTTP"
    
    # Test des en-têtes HTTP
    echo -e "${CYAN}📋 Analyse des en-têtes HTTP...${NC}"
    echo "En-têtes de réponse:"
    curl -I $WEBSITE_URL 2>/dev/null | head -10 || echo "Impossible de récupérer les en-têtes"
    echo ""
    
    # Test du contenu spécifique IPSSI
    echo -e "${CYAN}🎓 Vérification du contenu IPSSI...${NC}"
    run_detailed_test "Contenu IPSSI présent" \
        "curl -s $WEBSITE_URL | grep -i 'IPSSI'" \
        "Page contient les références IPSSI" \
        "Contenu IPSSI manquant sur la page"
    
    # Test des informations d'équipe
    run_detailed_test "Informations équipe présentes" \
        "curl -s $WEBSITE_URL | grep -E '(FIENI|Kaouthar|Amine)'" \
        "Noms de l'équipe présents sur la page" \
        "Informations d'équipe manquantes"
    
    # Test PHP
    run_detailed_test "PHP fonctionnel" \
        "curl -s $WEBSITE_URL | grep -i 'php'" \
        "PHP fonctionne et affiche les informations" \
        "PHP non fonctionnel ou non configuré"
    
    echo ""
}

# Tests de performance web
test_web_performance() {
    echo -e "${YELLOW}⚡ SECTION 4: Tests de Performance Web${NC}"
    echo "========================================="
    echo ""
    
    echo -e "${CYAN}⏱️ Mesure des temps de réponse...${NC}"
    
    # Test de temps de réponse
    RESPONSE_TIME=$(curl -w '%{time_total}' -s -o /dev/null $WEBSITE_URL)
    echo "Temps de réponse total: ${RESPONSE_TIME}s"
    
    # Vérifier que le temps est acceptable (< 5 secondes)
    run_test "Temps de réponse acceptable (< 5s)" \
        "[ \$(echo \"$RESPONSE_TIME < 5.0\" | bc -l) -eq 1 ]" false 30
    
    # Test de taille de réponse
    RESPONSE_SIZE=$(curl -w '%{size_download}' -s -o /dev/null $WEBSITE_URL)
    echo "Taille de la réponse: ${RESPONSE_SIZE} bytes"
    
    run_test "Taille de réponse significative (> 1KB)" \
        "[ $RESPONSE_SIZE -gt 1024 ]" false
    
    # Analyse détaillée des temps
    echo ""
    echo -e "${CYAN}📊 Analyse détaillée des performances:${NC}"
    curl -w "@-" -o /dev/null -s $WEBSITE_URL << 'EOF'
     time_namelookup:  %{time_namelookup}s
        time_connect:  %{time_connect}s
     time_appconnect:  %{time_appconnect}s
    time_pretransfer:  %{time_pretransfer}s
       time_redirect:  %{time_redirect}s
  time_starttransfer:  %{time_starttransfer}s
                     ----------
          time_total:  %{time_total}s
EOF
    echo ""
}

# Tests SSH et accès système
test_ssh_access() {
    echo -e "${YELLOW}🔐 SECTION 5: Tests d'Accès SSH${NC}"
    echo "==================================="
    echo ""
    
    # Vérifier que la clé SSH existe
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo -e "${YELLOW}⚠️ Clé SSH privée non trouvée. Tests SSH ignorés.${NC}"
        return
    fi
    
    echo -e "${CYAN}🔑 Test de connexion SSH...${NC}"
    
    # Test de connexion SSH basique
    run_detailed_test "Connexion SSH établie" \
        "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP 'exit'" \
        "Connexion SSH réussie" \
        "Impossible de se connecter en SSH"
    
    # Tests via SSH si la connexion fonctionne
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP 'exit' 2>/dev/null; then
        echo ""
        echo -e "${CYAN}🖥️ Tests système via SSH...${NC}"
        
        # Test des services
        echo "État des services critiques:"
        ssh -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP << 'EOF'
echo "• Apache2: $(systemctl is-active apache2)"
echo "• UFW Firewall: $(systemctl is-active ufw)"
echo "• SSH: $(systemctl is-active ssh)"
EOF
        
        echo ""
        echo "Informations système:"
        ssh -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP << 'EOF'
echo "• OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "• Kernel: $(uname -r)"
echo "• Uptime: $(uptime -p)"
echo "• Espace disque: $(df -h / | tail -1 | awk '{print $4}') disponible"
echo "• Mémoire libre: $(free -h | grep Mem | awk '{print $7}')"
EOF
        echo ""
        
        # Test du serveur web local
        echo -e "${CYAN}🧪 Test du serveur web en local (via SSH)...${NC}"
        ssh -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP \
            'curl -s -o /dev/null -w "HTTP Status: %{http_code}, Time: %{time_total}s\n" localhost'
    fi
    
    echo ""
}

# Tests Azure et infrastructure
test_azure_infrastructure() {
    echo -e "${YELLOW}☁️ SECTION 6: Tests Infrastructure Azure${NC}"
    echo "=========================================="
    echo ""
    
    # Vérifier la connexion Azure
    if ! az account show > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ Non connecté à Azure. Tests Azure ignorés.${NC}"
        echo "Lancez 'az login' pour tester l'infrastructure Azure."
        return
    fi
    
    echo -e "${CYAN}📊 Vérification des ressources Azure...${NC}"
    
    # Test du groupe de ressources
    run_detailed_test "Groupe de ressources existe" \
        "az group show --name $RESOURCE_GROUP" \
        "Groupe de ressources accessible" \
        "Groupe de ressources introuvable"
    
    # Compter les ressources
    if [ ! -z "$RESOURCE_GROUP" ]; then
        RESOURCE_COUNT=$(az resource list --resource-group $RESOURCE_GROUP --query 'length(@)' 2>/dev/null || echo "0")
        echo "Nombre de ressources déployées: $RESOURCE_COUNT"
        
        run_test "Ressources suffisantes déployées (≥10)" \
            "[ $RESOURCE_COUNT -ge 10 ]" true
        
        # Test de la VM
        if [ ! -z "$VM_NAME" ]; then
            run_detailed_test "Machine virtuelle en cours d'exécution" \
                "az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query 'powerState' | grep 'VM running'" \
                "VM en cours d'exécution" \
                "VM arrêtée ou problème d'état"
        fi
        
        # Test MySQL
        if [ ! -z "$MYSQL_SERVER" ]; then
            run_detailed_test "Serveur MySQL opérationnel" \
                "az mysql flexible-server show --resource-group $RESOURCE_GROUP --name $MYSQL_SERVER --query 'state' | grep 'Ready'" \
                "MySQL en état Ready" \
                "MySQL non opérationnel"
        fi
        
        # Test Storage
        if [ ! -z "$STORAGE_ACCOUNT" ]; then
            run_detailed_test "Compte de stockage disponible" \
                "az storage account show --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --query 'statusOfPrimary' | grep 'available'" \
                "Stockage disponible" \
                "Problème avec le stockage"
        fi
    fi
    
    echo ""
}

# Tests de sécurité
test_security() {
    echo -e "${YELLOW}🔒 SECTION 7: Tests de Sécurité${NC}"
    echo "===================================="
    echo ""
    
    echo -e "${CYAN}🛡️ Vérification de la sécurité réseau...${NC}"
    
    # Test que MySQL n'est PAS accessible depuis Internet (bon signe de sécurité)
    MYSQL_HOST=$(terraform output -raw mysql_server_fqdn 2>/dev/null || echo "")
    if [ ! -z "$MYSQL_HOST" ]; then
        run_detailed_test "MySQL non accessible depuis Internet (sécurisé)" \
            "! nc -zv -w 5 $MYSQL_HOST 3306" \
            "MySQL correctement sécurisé (non accessible)" \
            "ATTENTION: MySQL accessible depuis Internet!"
    fi
    
    # Test de l'authentification SSH
    echo -e "${CYAN}🔐 Test de sécurité SSH...${NC}"
    
    # Vérifier que l'authentification par mot de passe est désactivée
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP 'exit' 2>/dev/null; then
        echo "Vérification configuration SSH:"
        ssh -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP \
            'sudo grep "PasswordAuthentication\|PubkeyAuthentication" /etc/ssh/sshd_config | grep -v "^#"' || echo "Configuration SSH par défaut"
    fi
    
    # Test des ports ouverts (seulement ceux autorisés)
    echo -e "${CYAN}🚪 Vérification des ports ouverts...${NC}"
    if command -v nmap &> /dev/null; then
        echo "Scan des ports 1-1000:"
        OPEN_PORTS=$(nmap -p 1-1000 $PUBLIC_IP | grep "open" | wc -l)
        echo "Ports ouverts détectés: $OPEN_PORTS"
        
        # Normalement, seuls 22 et 80 devraient être ouverts
        run_test "Nombre de ports ouverts sécurisé (≤3)" \
            "[ $OPEN_PORTS -le 3 ]" false
    fi
    
    echo ""
}

# Tests d'intégration complète
test_full_integration() {
    echo -e "${YELLOW}🔄 SECTION 8: Test d'Intégration Complète${NC}"
    echo "============================================"
    echo ""
    
    echo -e "${CYAN}🧪 Scénario de test bout-en-bout...${NC}"
    
    # Scénario: Utilisateur visite le site
    echo "1. Un utilisateur accède au site web..."
    if curl -s $WEBSITE_URL > /tmp/webpage_content.html; then
        echo -e "   ${GREEN}✅ Page web téléchargée${NC}"
        
        # Vérifier le contenu téléchargé
        if grep -q "IPSSI" /tmp/webpage_content.html; then
            echo -e "   ${GREEN}✅ Contenu IPSSI vérifié${NC}"
        fi
        
        if grep -q "FIENI\|Kaouthar\|Amine" /tmp/webpage_content.html; then
            echo -e "   ${GREEN}✅ Informations équipe vérifiées${NC}"
        fi
        
        # Nettoyer
        rm -f /tmp/webpage_content.html
    else
        echo -e "   ${RED}❌ Impossible de télécharger la page${NC}"
    fi
    
    echo ""
    echo "2. Administrateur se connecte en SSH..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP 'whoami && pwd' > /tmp/ssh_test.out 2>/dev/null; then
        echo -e "   ${GREEN}✅ Connexion SSH administrateur réussie${NC}"
        echo "   Utilisateur connecté: $(cat /tmp/ssh_test.out | head -1)"
        rm -f /tmp/ssh_test.out
    else
        echo -e "   ${RED}❌ Échec de la connexion SSH${NC}"
    fi
    
    echo ""
    echo "3. Test de charge basique..."
    # Test de 10 requêtes simultanées
    echo "Envoi de 10 requêtes HTTP simultanées..."
    for i in {1..10}; do
        curl -s -o /dev/null $WEBSITE_URL &
    done
    wait
    echo -e "   ${GREEN}✅ Test de charge basique terminé${NC}"
    
    echo ""
}

# Génération du rapport final
generate_final_report() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    📊 RAPPORT FINAL                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # Statistiques
    echo -e "${CYAN}📈 Statistiques des Tests:${NC}"
    echo -e "   • Total des tests: $TOTAL_TESTS"
    echo -e "   • Tests réussis: ${GREEN}$PASSED_TESTS${NC} ✅"
    echo -e "   • Tests échoués: ${RED}$FAILED_TESTS${NC} ❌"
    
    PERCENTAGE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "   • Taux de réussite: ${PURPLE}$PERCENTAGE%${NC}"
    
    echo ""
    
    # Évaluation
    if [ $PERCENTAGE -ge 90 ]; then
        echo -e "${GREEN}🎉 EXCELLENT ! Infrastructure parfaitement fonctionnelle${NC}"
        GRADE="A+ (Excellent)"
    elif [ $PERCENTAGE -ge 80 ]; then
        echo -e "${GREEN}👍 TRÈS BIEN ! Infrastructure opérationnelle${NC}"
        GRADE="A (Très Bien)"
    elif [ $PERCENTAGE -ge 70 ]; then
        echo -e "${YELLOW}✔️ BIEN ! Infrastructure fonctionnelle avec quelques points d'amélioration${NC}"
        GRADE="B (Bien)"
    elif [ $PERCENTAGE -ge 60 ]; then
        echo -e "${YELLOW}⚠️ PASSABLE ! Infrastructure partiellement fonctionnelle${NC}"
        GRADE="C (Passable)"
    else
        echo -e "${RED}❌ INSUFFISANT ! Révisions nécessaires${NC}"
        GRADE="D (Insuffisant)"
    fi
    
    echo -e "${PURPLE}🎓 Évaluation: $GRADE${NC}"
    
    # Informations pour démonstration
    echo ""
    echo -e "${CYAN}🎯 Informations pour la Démonstration:${NC}"
    echo -e "   • Site web: ${GREEN}$WEBSITE_URL${NC}"
    echo -e "   • IP publique: ${GREEN}$PUBLIC_IP${NC}"
    echo -e "   • Connexion SSH: ${GREEN}$SSH_COMMAND${NC}"
    echo -e "   • Groupe de ressources: ${GREEN}$RESOURCE_GROUP${NC}"
    
    
    # Sauvegarde du rapport
    REPORT_FILE="test-connectivity-report-$(date +%Y%m%d-%H%M%S).txt"
    {
        echo "RAPPORT DE TESTS DE CONNECTIVITÉ - TP TERRAFORM IPSSI"
        echo "======================================================"
        echo "Date: $(date)"
        echo "Équipe: FIENI DANNIE (Chef), Kaouthar Brazi (Réseau), Amine Karassane (BDD)"
        echo ""
        echo "RÉSULTATS:"
        for result in "${TEST_RESULTS[@]}"; do
            echo "$result"
        done
        echo ""
        echo "STATISTIQUES:"
        echo "Total: $TOTAL_TESTS tests"
        echo "Réussis: $PASSED_TESTS"
        echo "Échoués: $FAILED_TESTS"
        echo "Taux de réussite: $PERCENTAGE%"
        echo "Évaluation: $GRADE"
        echo ""
        echo "INFORMATIONS INFRASTRUCTURE:"
        echo "Site web: $WEBSITE_URL"
        echo "IP publique: $PUBLIC_IP"
        echo "SSH: $SSH_COMMAND"
        echo "Groupe de ressources: $RESOURCE_GROUP"
    } > $REPORT_FILE
    
    echo ""
    echo -e "${BLUE}📄 Rapport sauvegardé: $REPORT_FILE${NC}"
    echo ""
    echo -e "${GREEN}✨ Tests de connectivité terminés ! Bonne chance pour votre soutenance IPSSI ! 🚀${NC}"
}

# Fonction principale
main() {
    print_header
    
    # Vérifications préalables
    check_prerequisites
    
    # Récupération des informations
    get_terraform_outputs
    
    # Exécution des tests par section
    test_basic_connectivity
    test_ports_and_services
    test_web_server
    test_web_performance
    test_ssh_access
    test_azure_infrastructure
    test_security
    test_full_integration
    
    # Rapport final
    generate_final_report
}

# Gestion des signaux
trap 'echo -e "\n${YELLOW}🛑 Tests interrompus${NC}"; exit 1' INT TERM

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi