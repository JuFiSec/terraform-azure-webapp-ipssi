# 🚀 Guide de Déploiement - TP Terraform IPSSI

**Infrastructure Web Azure avec Terraform**  
**École :** IPSSI Nice - M1 Cybersécurité & Cloud Computing  
**Équipe :** FIENI DANNIE (Chef), Kaouthar Brazi (Réseau), Amine Karassane (BDD)

---

## 📋 Table des Matières

1. [Prérequis](#-prérequis)
2. [Installation](#️-installation)
3. [Configuration](#️-configuration)
4. [Déploiement](#-déploiement)
5. [Vérification](#-vérification)
6. [Maintenance](#️-maintenance)

---

## 📋 Prérequis

### 🛠️ Outils Nécessaires

```bash
# Vérification des versions
terraform --version  # >= 1.0
az --version         # Azure CLI latest
git --version        # Git latest
```

### ☁️ Comptes et Accès

- ✅ **Compte Azure** avec crédits étudiants (100$)
- ✅ **Subscription Azure** active
- ✅ **Droits de création** de ressources
- ✅ **Accès Internet** stable

### 💻 Environnement Recommandé

- **OS :** WSL Ubuntu/Debian ou Linux natif
- **RAM :** Minimum 4GB
- **Espace disque :** 2GB libres
- **Terminal :** Bash compatible

---

## 🛠️ Installation

### 1️⃣ Installation d'Azure CLI

```bash
# Méthode officielle Microsoft
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Vérification
az --version
az login --help
```

### 2️⃣ Installation de Terraform

```bash
# Ajout du repository HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# Installation
sudo apt update && sudo apt install terraform

# Vérification
terraform --version
```

### 3️⃣ Configuration Git

```bash
# Configuration globale
git config --global user.name "FIENI DANNIE INNOCENT JUNIOR"
git config --global user.email "dij.fieni@ipssi.fr"

# Vérification
git config --list | grep user
```

### 4️⃣ Génération Clé SSH

```bash
# Génération (si pas déjà fait)
ssh-keygen -t rsa -b 4096 -C "dij.fieni@ecole-ipssi.fr"

# Affichage de la clé publique
cat ~/.ssh/id_rsa.pub
```

---

## ⚙️ Configuration

### 1️⃣ Connexion Azure

```bash
# Connexion interactive
az login

# Vérification de la connexion
az account show

# Liste des subscriptions disponibles
az account list --output table

# Sélection d'une subscription spécifique (si nécessaire)
az account set --subscription "VOTRE-SUBSCRIPTION-ID"
```

### 2️⃣ Clone du Projet

```bash
# Clonage du repository
git clone https://github.com/JuFiSec/terraform-azure-webapp-ipssi.git
cd terraform-azure-webapp-ipssi

# Vérification de la structure
ls -la
```

### 3️⃣ Configuration des Variables

```bash
# Copie du fichier d'exemple
cp terraform.tfvars.example terraform.tfvars

# Édition des variables (OBLIGATOIRE)
nano terraform.tfvars
```

**Contenu minimum de `terraform.tfvars` :**
```hcl
# OBLIGATOIRE: Mot de passe MySQL (8+ caractères)
mysql_admin_password = "IPSSI2025@Nice"

# OPTIONNEL: Personnalisations
# location = "France Central"
# vm_size = "Standard_B2s"
# admin_username = "adminuser"
```

**⚠️ Variables importantes :**
- **mysql_admin_password** : Minimum 8 caractères, majuscule + minuscule + chiffre
- **location** : "France Central" (recommandé pour IPSSI)
- **vm_size** : "Standard_B2s" (optimal pour TP)

---

## 🚀 Déploiement

### Méthode 1 : Script Automatique (Recommandé)

```bash
# Utilisation du script de déploiement
chmod +x deploy.sh
./deploy.sh
```

### Méthode 2 : Déploiement Manuel

#### 1️⃣ Initialisation
```bash
# Initialisation Terraform
terraform init

# Validation de la configuration
terraform validate

# Formatage du code
terraform fmt -recursive
```

#### 2️⃣ Planification
```bash
# Génération du plan
terraform plan -out=tfplan

# Vérification du plan
terraform show tfplan | head -50
```

#### 3️⃣ Application
```bash
# Déploiement (ATTENTION: Ressources payantes!)
terraform apply tfplan

# OU déploiement interactif
terraform apply
```

**⏱️ Temps de déploiement estimé :** 10-15 minutes

### 3️⃣ Monitoring du Déploiement

```bash
# Dans un autre terminal, surveiller les ressources
watch -n 30 "az resource list --resource-group rg-webapp-ipssi-dev --output table"
```

---

## ✅ Vérification

### 1️⃣ Vérification des Outputs

```bash
# Affichage de tous les outputs
terraform output

# Outputs spécifiques
echo "Site web: $(terraform output -raw website_url)"
echo "SSH: $(terraform output -raw ssh_connection_command)"
echo "IP: $(terraform output -raw public_ip_address)"
```

### 2️⃣ Tests de Connectivité

```bash
# Test ping
ping -c 3 $(terraform output -raw public_ip_address)

# Test HTTP
curl -I $(terraform output -raw website_url)

# Test SSH
timeout 10 ssh adminuser@$(terraform output -raw public_ip_address) "uname -a"
```

### 3️⃣ Vérification Infrastructure Azure

```bash
# Liste des ressources créées
RG_NAME=$(terraform output -raw resource_group_name)
az resource list --resource-group $RG_NAME --output table

# État de la VM
VM_NAME=$(terraform output -raw vm_name)
az vm show --resource-group $RG_NAME --name $VM_NAME --show-details

# État MySQL
MYSQL_SERVER=$(terraform output -raw mysql_server_name)
az mysql flexible-server show --resource-group $RG_NAME --name $MYSQL_SERVER
```

### 4️⃣ Test du Site Web

```bash
# Test de contenu IPSSI
WEBSITE_URL=$(terraform output -raw website_url)
curl -s $WEBSITE_URL | grep -i "IPSSI\|Cybersécurité\|FIENI\|Kaouthar\|Amine"
```

---

## 🛠️ Maintenance

### 📊 Monitoring

```bash
# Surveillance continue des ressources
az monitor metrics list \
    --resource $(terraform output -raw vm_id) \
    --metric "Percentage CPU" \
    --interval PT1M

# Logs de la VM
az vm boot-diagnostics get-boot-log \
    --resource-group $(terraform output -raw resource_group_name) \
    --name $(terraform output -raw vm_name)
```

### 🔄 Mise à Jour

```bash
# Mise à jour des modules
terraform get -update

# Nouveau plan après modifications
terraform plan

# Application des changements
terraform apply
```

### 💾 Sauvegarde

```bash
# Export de l'état Terraform
terraform show > infrastructure-state.txt

# Sauvegarde de la configuration
tar -czf backup-$(date +%Y%m%d).tar.gz *.tf *.tfvars terraform.tfstate
```

### 🧹 Nettoyage

**⚠️ ATTENTION : Cette action supprime TOUTE l'infrastructure !**

```bash
# Suppression de l'infrastructure
terraform destroy

# Confirmation requise
# Tapez 'yes' pour confirmer
```

---

## 🐛 Dépannage

### ❌ Erreurs Courantes

#### 1. Erreur de Quota Azure
```bash
# Problème: "Quota exceeded"
# Solution: Changer la taille de VM
# Dans terraform.tfvars:
vm_size = "Standard_B1s"  # Plus petit
```

#### 2. Erreur MySQL SKU
```bash
# Problème: "invalid sku name"
# Solution: Utiliser un SKU valide
# Dans database/main.tf:
sku_name = "B_Standard_B1ms"
```

#### 3. Erreur Storage Account
```bash
# Problème: "storage account name invalid"
# Solution: Nom avec caractères alphanumériques uniquement
```

#### 4. Timeout SSH
```bash
# Vérifications:
# 1. VM démarrée?
az vm show --resource-group $RG_NAME --name $VM_NAME --show-details --query "powerState"

# 2. NSG correctement configuré?
az network nsg rule list --resource-group $RG_NAME --nsg-name nsg-webapp-ipssi-web

# 3. Clé SSH correcte?
cat ~/.ssh/id_rsa.pub
```

### 🔧 Scripts de Diagnostic

```bash
# Script de diagnostic automatique
terraform validate
terraform plan
az account show
ping -c 1 $(terraform output -raw public_ip_address 2>/dev/null || echo "8.8.8.8")
```

---

## 📞 Support

### 📧 Contacts Équipe IPSSI
- **Chef de Projet** : FIENI DANNIE INNOCENT JUNIOR - dij.fieni@ecole-ipssi.fr
- **Responsable Réseau** : Kaouthar Brazi - k.brazi@ecole-ipssi.net
- **Responsable BDD** : Amine Karassane - a.karassane@ecole-ipssi.net

### 📚 Ressources Utiles
- [Documentation Terraform Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://docs.microsoft.com/cli/azure/)
- [Azure VM Sizes](https://docs.microsoft.com/azure/virtual-machines/sizes)

### 🆘 En Cas de Problème
1. **Vérifiez les logs** : `terraform show`
2. **Consultez ce guide** : Section Dépannage
3. **Contactez l'équipe** : Emails ci-dessus
4. **Documentation officielle** : Liens ci-dessus

---


*© 2025 - M1 Cybersécurité & Cloud Computing - IPSSI Nice*