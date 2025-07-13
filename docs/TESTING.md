# 🧪 Guide de Tests - TP Terraform IPSSI

**Tests de Validation Infrastructure Web Azure**  
**École :** IPSSI Nice - M1 Cybersécurité & Cloud Computing  
**Équipe :** FIENI DANNIE (Chef), Kaouthar Brazi (Réseau), Amine Karassane (BDD)

---

## 📋 Table des Matières

1. [Tests Automatiques](#-tests-automatiques)
2. [Tests Manuels](#️-tests-manuels)
3. [Validation Sécurité](#-validation-sécurité)
4. [Tests Performance](#⚡-tests-performance)
5. [Checklist Évaluation](#-checklist-évaluation)

---

## 🤖 Tests Automatiques

### 🚀 Script de Tests Complet

```bash
# Lancement des tests automatiques
chmod +x test-connectivity.sh
./test-connectivity.sh
```

### 📊 Sections de Tests Automatiques

Le script `test-connectivity.sh` couvre 8 sections :

#### 1. **Tests de Connectivité Réseau**
- Ping vers IP publique
- Test de latence
- Résolution DNS

#### 2. **Tests des Ports et Sécurité**
- Port SSH (22)
- Port HTTP (80)  
- Port HTTPS (443)
- Scan Nmap (si disponible)

#### 3. **Tests du Serveur Web IPSSI**
- Réponse HTTP 200
- Contenu "IPSSI Nice"
- Noms équipe présents
- PHP fonctionnel

#### 4. **Tests de Performance**
- Temps de réponse
- Taille de réponse
- Évaluation selon critères IPSSI

#### 5. **Tests d'Accès SSH**
- Connexion SSH
- Informations système
- État des services

#### 6. **Tests Infrastructure Azure**
- Ressources déployées
- État VM/MySQL/Storage
- Vérification région France Central

#### 7. **Tests de Sécurité**
- MySQL non accessible Internet
- Configuration SSH
- Audit des ports

#### 8. **Tests d'Intégration**
- Scénarios bout-en-bout
- Test de charge basique

---

## 🛠️ Tests Manuels

### 1️⃣ Validation Terraform

```bash
# Test de syntaxe
terraform validate
# Résultat attendu: "Success! The configuration is valid."

# Test de formatage
terraform fmt -check -recursive
# Résultat attendu: Aucune modification nécessaire

# Test de planification
terraform plan
# Résultat attendu: Plan cohérent sans erreurs
```

### 2️⃣ Tests Infrastructure Azure

```bash
# Connexion et vérification
az login
az account show

# Liste des ressources déployées
RG_NAME=$(terraform output -raw resource_group_name)
az resource list --resource-group $RG_NAME --output table

# Vérification VM
VM_NAME=$(terraform output -raw vm_name)
az vm show --resource-group $RG_NAME --name $VM_NAME --show-details --query "powerState"
# Résultat attendu: "VM running"

# Vérification MySQL
MYSQL_SERVER=$(terraform output -raw mysql_server_name)
az mysql flexible-server show --resource-group $RG_NAME --name $MYSQL_SERVER --query "state"
# Résultat attendu: "Ready"
```

### 3️⃣ Tests de Connectivité Web

```bash
# Test ping vers infrastructure
PUBLIC_IP=$(terraform output -raw public_ip_address)
ping -c 4 $PUBLIC_IP
# Résultat attendu: 4 paquets transmis et reçus

# Test HTTP
WEBSITE_URL=$(terraform output -raw website_url)
curl -I $WEBSITE_URL
# Résultat attendu: HTTP/1.1 200 OK

# Test contenu IPSSI
curl -s $WEBSITE_URL | grep -i "IPSSI\|Cybersécurité\|FIENI\|Kaouthar\|Amine"
# Résultat attendu: Contenu équipe trouvé
```

### 4️⃣ Tests SSH et Système

```bash
# Test de connexion SSH
SSH_COMMAND=$(terraform output -raw ssh_connection_command)
timeout 10 ssh -o StrictHostKeyChecking=no adminuser@$PUBLIC_IP "uname -a"
# Résultat attendu: Information système Ubuntu

# Test des services via SSH
ssh adminuser@$PUBLIC_IP << 'EOF'
echo "=== État des Services ==="
systemctl status apache2 --no-pager
systemctl status ufw --no-pager
echo "=== Informations Système ==="
free -h
df -h /
ps aux | grep apache2 | head -3
EOF
```

---

## 🔒 Validation Sécurité

### 🛡️ Tests de Sécurité Réseau

```bash
# Test critique: MySQL NON accessible depuis Internet
MYSQL_HOST=$(terraform output -raw mysql_server_fqdn)
timeout 5 nc -zv $MYSQL_HOST 3306
# Résultat attendu: ÉCHEC (bon signe de sécurité)

# Test ports ouverts autorisés uniquement
nmap -p 22,80,443 $PUBLIC_IP
# Résultat attendu: Seulement 22 et 80 ouverts

# Test configuration SSH sécurisée
ssh adminuser@$PUBLIC_IP 'sudo grep "PasswordAuthentication\|PubkeyAuthentication" /etc/ssh/sshd_config'
# Résultat attendu: Auth par clé activée
```

### 🔍 Audit de Sécurité

#### Checklist Sécurité IPSSI Cybersécurité

- [ ] **MySQL en réseau privé** ✅ Non accessible depuis Internet
- [ ] **SSH par clés uniquement** ✅ Pas d'auth par mot de passe
- [ ] **Firewall UFW actif** ✅ Règles configurées
- [ ] **Ports minimaux ouverts** ✅ Seulement 22, 80, 443
- [ ] **NSG correctement configuré** ✅ Règles réseau Azure
- [ ] **Pas de root login SSH** ✅ Utilisateur admin seulement

#### Tests de Pénétration Basiques

```bash
# Scan de vulnérabilités basique
nmap -sV -p 1-1000 $PUBLIC_IP

# Test brute force SSH (éthique - pour test)
# Ne PAS faire en production !
timeout 10 ssh -o ConnectTimeout=2 root@$PUBLIC_IP
# Résultat attendu: Connexion refusée

# Vérification headers sécuritaires
curl -I $WEBSITE_URL | grep -i "server\|x-"
```

---

## ⚡ Tests Performance

### 📊 Benchmarks Web

```bash
# Test de temps de réponse
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


### 🧪 Tests de Charge

```bash
# Test Apache Bench (si disponible)
sudo apt install apache2-utils -y
ab -n 100 -c 10 $WEBSITE_URL

# Test de charge simple avec curl
for i in {1..10}; do
    curl -s -o /dev/null -w "%{time_total}\n" $WEBSITE_URL &
done
wait
```

### 📈 Monitoring Ressources

```bash
# Via SSH sur la VM
ssh adminuser@$PUBLIC_IP << 'EOF'
echo "=== Utilisation Ressources ==="
top -bn1 | head -15
echo "=== Espace Disque ==="
df -h
echo "=== Mémoire ==="
free -h
echo "=== Réseau ==="
ss -tuln | grep ":80\|:22\|:443"
EOF
```

---

## 📋 Checklist Évaluation

### ✅ Tests Infrastructure 

- [ ] **Terraform validate** ✅ Configuration valide
- [ ] **14+ ressources Azure** ✅ Infrastructure complète
- [ ] **VM opérationnelle** ✅ État "running"
- [ ] **MySQL accessible** ✅ État "Ready"
- [ ] **Storage configuré** ✅ Containers créés

### ✅ Tests Fonctionnels 

- [ ] **Site web accessible** ✅ HTTP 200
- [ ] **Contenu IPSSI présent** ✅ Texte équipe
- [ ] **PHP fonctionnel** ✅ Informations dynamiques
- [ ] **SSH opérationnel** ✅ Connexion par clé
- [ ] **Services actifs** ✅ Apache + UFW

### ✅ Tests Sécurité 

- [ ] **MySQL sécurisé** ✅ Réseau privé
- [ ] **SSH sécurisé** ✅ Clés uniquement
- [ ] **Firewall actif** ✅ UFW configuré
- [ ] **Ports minimaux** ✅ 22, 80 seulement
- [ ] **NSG configuré** ✅ Règles Azure

### ✅ Tests Performance 

- [ ] **Temps réponse < 5s** ✅ Performance web
- [ ] **Charge supportée** ✅ 10 requêtes simultanées
- [ ] **Ressources optimales** ✅ CPU/RAM normaux

### ✅ Documentation 

- [ ] **README complet** ✅ Avec captures
- [ ] **Tests documentés** ✅ Procédures claires



---

## 📞 Support Tests

### 🔧 Dépannage Tests

```bash
# Si test-connectivity.sh échoue
chmod +x test-connectivity.sh
./test-connectivity.sh 2>&1 | tee test-results.log

# Si tests SSH échouent
cat ~/.ssh/id_rsa.pub  # Vérifier clé
ssh -v adminuser@$PUBLIC_IP  # Debug verbose

# Si tests web échouent
curl -v $WEBSITE_URL  # Debug HTTP
ssh adminuser@$PUBLIC_IP "systemctl status apache2"  # État Apache
```

### 📊 Génération Rapport de Tests

```bash
# Script de rapport automatique
./test-connectivity.sh > rapport-tests-$(date +%Y%m%d).txt
echo "📄 Rapport généré pour le professeur"
```

---

**🧪 Tests validés par l'équipe IPSSI Nice ! 🎓**

*© 2025 - M1 Cybersécurité & Cloud Computing - IPSSI Nice*