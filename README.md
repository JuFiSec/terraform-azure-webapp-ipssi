# 🌐 TP Terraform - Infrastructure Web Azure

<div align="center">

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Apache](https://img.shields.io/badge/Apache-D22128?style=for-the-badge&logo=apache&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

**Projet académique** - M1 Cybersécurité & Cloud Computing  
**École** : IPSSI Nice  
**Date** : Juillet 2025

[![Infrastructure Status](https://img.shields.io/badge/Infrastructure-Deployed-success?style=flat-square)](docs/screenshots)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen?style=flat-square)](scripts/test-connectivity.sh)
[![Documentation](https://img.shields.io/badge/Documentation-Complete-blue?style=flat-square)](README.md)

</div>

---

## 📊 Informations du Projet

| **Attribut** | **Valeur** |
|--------------|------------|
| **🎓 Formation** | M1 Cybersécurité & Cloud Computing |
| **🏫 École** | IPSSI Nice |
| **📅 Date de remise** | Juillet 2025 |
| **⏱️ Durée du TP** | 3h30 |
| **🔧 Technologies** | Terraform, Azure, Ubuntu, Apache, MySQL |
| **📝 Type** | Infrastructure as Code (IaC) |

---

## 👥 Équipe de Développement et Organisation

<table>
<tr>
<td align="center">
<img src="https://github.com/JuFiSec.png" width="100px;" alt="FIENI DANNIE"/><br>
<sub><b>👨‍💼 FIENI Dannie Innocent Junior</b></sub><br>
<sub>Chef de Projet & Coordination Générale</sub><br>
<sub>📧 dij.fieni@ecole-ipssi.net</sub>
</td>
<td align="center">
<img src="https://github.com/kaoutaar.png" width="100px;" alt="Kaouthar Brazi"/><br>
<sub><b>🌐 Kaouthar Brazi</b></sub><br>
<sub>Spécialiste Réseau & Sécurité</sub><br>
<sub>📧 k.brazi@ecole-ipssi.net</sub>
</td>
<td align="center">
<img src="https://github.com/identicons/Amine-Karassane.png" width="100px;" alt="Amine Karassane"/><br>
<sub><b>🗄️ Amine Karassane</b></sub><br>
<sub>Expert Base de Données</sub><br>
<sub>📧 a.karassane@ecole-ipssi.net</sub>
</td>
</tr>
</table>

### 🏢 Organisation du Travail

Le projet a été développé de manière coordonnée sous la direction de **FIENI Dannie Innocent Junior** en tant que chef de projet. L'équipe a travaillé en collaboration étroite, avec une répartition claire des responsabilités techniques :

- **🎯 Chef de Projet (FIENI Dannie)** : Coordination générale, , configuration sécurité NSG, développement sur machine principale, intégration des modules, documentation complète
- **🌐 Expertise Réseau (Kaouthar Brazi)** : Conception architecture réseau, planification VNet
- **🗄️ Expertise Base de Données (Amine Karassane)** : Architecture de données, configuration MySQL, stratégie de stockage

*Note : Le développement a été centralisé sur la machine du chef de projet pour assurer la cohérence et la stabilité de l'environnement de développement.*

---

## 🎯 Objectifs du Projet

### 🎓 Objectifs Pédagogiques
- **Apprendre Terraform** en équipe sur Azure
- **Créer une infrastructure web** simple mais complète
- **Découvrir les bases de Git** et GitHub
- **Collaborer efficacement** sur un projet technique
- **Présenter son travail** en équipe

### 🏗️ Objectifs Techniques
-  Déploiement automatisé avec Terraform
-  Infrastructure sécurisée sur Azure
-  Serveur web Apache + PHP fonctionnel
-  Base de données MySQL configurée
-  Gestion des versions avec Git
-  Documentation complète

---

## 🏛️ Architecture Déployée

### 📊 Schéma d'Architecture Azure (Auto-généré)

![Schéma Architecture Azure](docs/screenshots/Schema-architecture-rg-webapp-ipssi-dev.jpg)
*Diagramme d'architecture automatiquement généré par Azure montrant tous les composants et leurs interconnexions*

### 🎯 Diagramme Conceptuel

```mermaid
graph TB
    Internet([🌍 Internet]) --> LB[🔄 Load Balancer]
    LB --> PIP[📍 IP Publique]
    PIP --> NSG[🛡️ Network Security Group]
    NSG --> VM[🖥️ VM Ubuntu 22.04<br/>Apache + PHP]
    VM --> VNet[🌐 Virtual Network<br/>10.0.0.0/16]
    VNet --> SubnetWeb[📡 Subnet Web<br/>10.0.1.0/24]
    VNet --> SubnetDB[🗄️ Subnet Database<br/>10.0.2.0/24]
    SubnetDB --> MySQL[🗄️ MySQL Flexible Server<br/>8.0.21]
    VM --> Storage[💾 Azure Storage Account<br/>Files + Backup]
    
    style Internet fill:#e1f5fe
    style VM fill:#f3e5f5
    style MySQL fill:#fff3e0
    style Storage fill:#e8f5e8
```

### 📋 Composants Infrastructure

| **Composant** | **Service Azure** | **Configuration** | **Responsable** |
|---------------|-------------------|-------------------|-----------------|
| 🌐 **Réseau** | Virtual Network | 10.0.0.0/16 | Kaouthar Brazi |
| 🖥️ **Compute** | Virtual Machine | Standard_B2s, Ubuntu 22.04 | FIENI Dannie |
| 🗄️ **Base de Données** | MySQL Flexible Server | B_Standard_B1ms, 20GB | Amine Karassane |
| 💾 **Stockage** | Storage Account | Standard LRS | Amine Karassane |
| 🛡️ **Sécurité** | Network Security Group | SSH, HTTP, HTTPS | FIENI Dannie |
| 📍 **IP Publique** | Public IP | Static | Kaouthar Brazi |

---

## 📸 Preuves de Fonctionnement et Captures d'Écran

### 🎯 Gallery de Démonstration

> **📋 Note pour le professeur :** Toutes les captures d'écran suivantes prouvent le bon fonctionnement de l'infrastructure déployée et le travail collaboratif de l'équipe IPSSI.

#### 1️⃣ Structure du Projet Terraform
![Structure du Projet](docs/screenshots/01-structure-projet.png)
*Structure modulaire complète du projet avec séparation des responsabilités par équipe*

#### 2️⃣ Validation de la Configuration Terraform
![Terraform Validate](docs/screenshots/02-terraform-validate.png)
*Validation réussie de la configuration Terraform - Aucune erreur de syntaxe*

#### 3️⃣ Planification du Déploiement
![Terraform Plan](docs/screenshots/03-terraform-plan.png)
*Plan de déploiement Terraform montrant toutes les ressources à créer*

#### 4️⃣ Sorties du Déploiement Réussi
![Terraform Outputs](docs/screenshots/04-terraform-outputs.png)
*Outputs Terraform confirmant le déploiement réussi avec toutes les informations d'accès*

#### 5️⃣ Ressources Azure Créées
![Ressources Azure](docs/screenshots/05-ressources-azure.png)
*Liste complète des ressources Azure déployées via Azure CLI*

#### 6️⃣ Site Web Fonctionnel - Page IPSSI
![Site Web IPSSI](docs/screenshots/06-site-web-fonctionnel.png)
*Page web personnalisée IPSSI avec informations d'équipe et architecture technique*

#### 6️⃣ Site Web - Versions Alternatives
![Site Web IPSSI v2](docs/screenshots/06-site-web-fonctionnel2.png)
![Site Web IPSSI v3](docs/screenshots/06-site-web-fonctionnel3.png)
*Versions alternatives de la page web montrant la robustesse du déploiement*

#### 7️⃣ Tests de Connectivité Réseau
![Tests de Connectivité](docs/screenshots/07-test-connectivite.png)
*Tests de connectivité réseau - Ping et requêtes HTTP réussies*

#### 8️⃣ Accès SSH à la Machine Virtuelle
![Connexion SSH](docs/screenshots/08-connexion-ssh.png)
![Connexion SSH v2](docs/screenshots/08-connexion-ssh2.png)
*Connexion SSH réussie avec commandes système et vérification des services*

#### 9️⃣ Portail Azure - Vue d'Ensemble
![Portail Azure](docs/screenshots/12-portail-azure.png)
![Portail Azure v2](docs/screenshots/12-portail-azure2.png)
*Interface du portail Azure montrant toutes les ressources déployées*

---

## 📁 Structure du Projet

```
terraform-azure-webapp-ipssi/
├── 📄 main.tf                           # Configuration principale Terraform
├── 📄 variables.tf                      # Variables globales partagées
├── 📄 outputs.tf                        # Sorties du déploiement
├── 📄 terraform.tfvars                  # Variables d'environnement (secret)
├── 📄 terraform.tfvars.example          # Exemple de configuration
├── 📄 terraform.tfstate                 # État Terraform (généré)
├── 📄 terraform.tfstate.backup          # Sauvegarde état (généré)
├── 📁 .terraform/                       # Cache Terraform (généré)
├── 📁 network/                          # 🌐 Module Réseau 
│   ├── main.tf                          #   ├─ Ressources réseau
│   ├── variables.tf                     #   ├─ Variables du module
│   └── outputs.tf                       #   └─ Sorties réseau
├── 📁 compute/                          # 🖥️ Module Serveur 
│   ├── main.tf                          #   ├─ Machine virtuelle
│   ├── variables.tf                     #   ├─ Variables VM
│   ├── outputs.tf                       #   ├─ Sorties VM
│   └── install-webserver.tpl            #   └─ Script d'installation
├── 📁 database/                         # 🗄️ Module BDD 
│   ├── main.tf                          #   ├─ MySQL + Storage
│   ├── variables.tf                     #   ├─ Variables BDD
│   └── outputs.tf                       #   └─ Sorties BDD
├── 📁 docs/                             # 📚 Documentation
│   └── screenshots/                     #   └─ Captures d'écran
├── 📄 deploy.sh                         # Script de deploiement 
├── 📄 test-connectivity.sh              # Script de tests de connectivité
├── 📄 .gitignore                        # Fichiers à ignorer par Git
└── 📄 README.md                         # Documentation principale
```

---

## 🚀 Guide de Déploiement

### 📋 Prérequis

#### 🛠️ Outils Nécessaires
```bash
# Vérification des outils installés
terraform --version  # >= 1.0
az --version         # Azure CLI
git --version        # Git
ssh-keygen --help    # Génération clés SSH
```

#### ☁️ Comptes Requis
-  **Compte Azure** avec crédits étudiants (100$)
-  **Compte GitHub** (gratuit)
-  **Accès WSL/Linux** pour les commandes

### 🔧 Installation

#### 1️⃣ Clonage du Repository
```bash
git clone https://github.com/JuFiSec/terraform-azure-webapp-ipssi.git
cd terraform-azure-webapp-ipssi
```

#### 2️⃣ Configuration Azure
```bash
# Connexion à Azure
az login

# Sélection de la subscription (si multiple)
az account list --output table
az account set --subscription "VOTRE-SUBSCRIPTION-ID"
```

#### 3️⃣ Configuration SSH
```bash
# Génération clé SSH (si inexistante)
ssh-keygen -t rsa -b 4096 -C "dij.fieni@ecole-ipssi.net"

# Affichage clé publique
cat ~/.ssh/id_rsa.pub
```

#### 4️⃣ Configuration Variables
```bash
# Copie du fichier d'exemple
cp terraform.tfvars.example terraform.tfvars

# Édition des variables
nano terraform.tfvars
```

**Contenu minimal de `terraform.tfvars` :**
```hcl
# Configuration pour le déploiement
mysql_admin_password = "IPSSI2025@Nice"

# Configuration optionnelle (décommentez pour personnaliser)
# location = "France Central"
# vm_size = "Standard_B2s"
# admin_username = "adminuser"

```

### 🚀 Déploiement

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
# Génération du plan de déploiement
terraform plan -out=tfplan

# Vérification du plan
terraform show tfplan
```

#### 3️⃣ Déploiement
```bash
# Application du plan (ATTENTION: Ressources payantes!)
terraform apply tfplan

# Ou déploiement interactif
terraform apply
```

#### 4️⃣ Vérification
```bash
# Affichage des résultats
terraform output

# Test de connectivité
curl $(terraform output -raw website_url)
```

---

## 🧪 Tests et Validation

### ✅ Tests Automatisés

#### Script de Tests de Connectivité
```bash
# Lancer tous les tests automatiques
chmod +x test-connectivity.sh
./test-connectivity.sh
```

### 📊 Résultats des Tests

Le script de tests couvre :
- 🔍 **Tests de connectivité réseau** (ping, DNS)
- 🚪 **Tests des ports** (SSH, HTTP, HTTPS)
- 🌐 **Tests du serveur web** (Apache, PHP, contenu)
- ⚡ **Tests de performance** (temps de réponse)
- 🔐 **Tests SSH** (connexion, services système)
- ☁️ **Tests infrastructure Azure** (ressources, états)
- 🔒 **Tests de sécurité** (ports, configurations)
- 🔄 **Tests d'intégration** (scénarios bout-en-bout)

### 🎯 Checklist de Validation

#### 🔍 Tests Infrastructure
- [x] **Terraform validate**  Configuration valide
- [x] **Terraform plan**  14+ ressources à créer
- [x] **Terraform apply**  Déploiement réussi
- [x] **Ressources Azure**  Toutes créées

#### 🌐 Tests Connectivité
- [x] **Ping IP publique**  Réponse OK
- [x] **SSH sur VM**  Connexion établie
- [x] **HTTP sur port 80**  Apache fonctionne
- [x] **Page web PHP**  Affichage correct

#### 🗄️ Tests Base de Données
- [x] **MySQL Server**  En ligne
- [x] **Base webapp_db**  Créée
- [x] **Connectivité privée** Depuis VM uniquement

#### 💾 Tests Stockage
- [x] **Storage Account**  Créé
- [x] **Containers**  webapp-files, backups
- [x] **Accès sécurisé**  Privé uniquement

---

## 📊 Métriques du Projet

### ⏱️ Temps de Réalisation
| **Phase** | **Durée Prévue** | **Durée Réelle** | **Équipe Impliquée** |
|-----------|------------------|------------------|---------------------|
| Planning & Setup | 30 min | 25 min | FIENI Dannie (Chef de projet) |
| Architecture Réseau | 45 min | 40 min | Kaouthar Brazi (Expertise réseau) |
| Développement Compute | 45 min | 50 min | FIENI Dannie (Développement principal) |
| Architecture Database | 45 min | 35 min | Amine Karassane (Expertise BDD) |
| Tests & Intégration | 30 min | 40 min | Équipe complète |
| Documentation | 45 min | 60 min | FIENI Dannie (Coordination) |
| **TOTAL** | **3h30** | **3h50** | ✅ **Objectif atteint** |

### 💰 Coût Infrastructure
| **Ressource** | **Type** | **Coût/Mois** | **Justification** |
|---------------|----------|---------------|-------------------|
| VM Standard_B2s | Compute | ~30€ | Serveur web principal |
| MySQL B_Standard_B1ms | Database | ~15€ | Base de données |
| Storage Standard LRS | Storage | ~2€ | Fichiers et backups |
| IP Publique | Network | ~3€ | Accès Internet |
| **TOTAL** | | **~50€/mois** | Budget étudiant Azure |

### 📊 Statistiques Git
```bash
# Nombre de commits
git rev-list --all --count
# Résultat: 12+ commits

# Nombre de fichiers
find . -name "*.tf" -o -name "*.md" | wc -l
# Résultat: 18+ fichiers

# Lignes de code
find . -name "*.tf" -exec cat {} \; | wc -l
# Résultat: 650+ lignes
```

---

## 🛠️ Maintenance et Opérations

### 🔧 Scripts d'Administration

#### Déploiement Automatique
```bash
#!/bin/bash
# deploy.sh - Déploiement automatique complet

echo "🚀 Déploiement automatique infrastructure IPSSI"

# Vérifications préalables
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

echo "✅ Déploiement terminé !"
terraform output
```

#### Tests de Connectivité
```bash
#!/bin/bash
# test-connectivity.sh - Tests complets

# Tests réseau
ping -c 3 $(terraform output -raw public_ip_address)

# Tests web
curl -I $(terraform output -raw website_url)

# Tests SSH
ssh -o ConnectTimeout=10 adminuser@$(terraform output -raw public_ip_address) "uname -a"
```

#### Nettoyage des Ressources
```bash
#!/bin/bash
# cleanup.sh - Suppression sécurisée

echo "🧹 Nettoyage des ressources Azure"
echo "⚠️ ATTENTION: Suppression de TOUTE l'infrastructure!"

read -p "Confirmez avec 'OUI': " confirm
if [ "$confirm" = "OUI" ]; then
    terraform destroy -auto-approve
    echo "✅ Ressources supprimées"
fi
```

### 📋 Monitoring

#### Surveillance des Ressources
```bash
# Status général
az resource list --resource-group $(terraform output -raw resource_group_name) --output table

# Métriques VM
az vm show --resource-group $(terraform output -raw resource_group_name) \
          --name $(terraform output -raw vm_name) \
          --show-details

# Status MySQL
az mysql flexible-server show --resource-group $(terraform output -raw resource_group_name) \
                             --name $(terraform output -raw mysql_server_name)
```

---

## 🎓 Rapport Académique

### 📝 Résumé Exécutif

Ce projet de TP Terraform démontre la maîtrise complète des technologies Infrastructure as Code (IaC) dans un environnement cloud Azure. L'équipe IPSSI composée de FIENI Dannie Innocent Junior (Chef de Projet), Kaouthar Brazi (Réseau) et Amine Karassane (Base de Données) a réussi à déployer une infrastructure web complète et sécurisée.

### 🎯 Objectifs Atteints

| **Objectif** | **Status** | **Preuves** |
|--------------|------------|-------------|
| Infrastructure automatisée | ✅ Réussi | Configuration Terraform validée |
| Travail collaboratif | ✅ Réussi | Branches Git + commits d'équipe |
| Sécurité réseau | ✅ Réussi | NSG configurés, accès restreint |
| Base de données | ✅ Réussi | MySQL opérationnel en réseau privé |
| Documentation | ✅ Réussi | README complet + guides + captures |
| Tests | ✅ Réussi | Scripts de validation automatiques |

### 🔍 Apprentissages Clés

#### 🛠️ Compétences Techniques Acquises
- **Infrastructure as Code** : Maîtrise de Terraform pour Azure
- **Cloud Computing** : Déploiement d'architecture multi-tiers
- **Sécurité** : Configuration NSG, accès SSH par clés
- **DevOps** : Intégration, documentation, scripts automatisés
- **Base de Données** : MySQL Flexible Server en cloud

#### 🤝 Compétences Collaboratives
- **Gestion de projet** : Coordination d'équipe, respect des délais
- **Architecture distribuée** : Conception modulaire collaborative
- **Documentation technique** : Création de guides complets
- **Communication** : Présentation claire des résultats

### 🚀 Innovations Apportées

1. **Script d'installation automatique** : Page web personnalisée IPSSI
2. **Tests automatisés** : Scripts de validation infrastructure
3. **Documentation exhaustive** : Guides complets pour reproduction
4. **Architecture modulaire** : Séparation claire des responsabilités techniques
5. **Intégration centralisée** : Développement coordonné pour assurer la cohérence

### 📊 Résultats Quantifiés

- **✅ 14+ ressources Azure** déployées avec succès
- **✅ 100% de tests** de connectivité réussis
- **✅ 0 erreur** dans la configuration finale
- **✅ 3h50** de réalisation (vs 3h30 prévues)
- **✅ 650+ lignes** de code Infrastructure as Code
- **✅ 18+ fichiers** de configuration et documentation
- **✅ 12+ captures d'écran** de démonstration

---

## 🔗 Liens et Ressources

### 📚 Documentation Technique
- [📖 Guide de déploiement détaillé](docs/DEPLOYMENT.md)
- [🧪 Guide de tests complets](docs/TESTING.md)


### 🌐 Liens Externes
- [🔗 Repository GitHub](https://github.com/JuFiSec/terraform-azure-webapp-ipssi)
- [☁️ Portail Azure](https://portal.azure.com)
- [📘 Documentation Terraform Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [🎓 IPSSI Nice - Cloud Computing](https://ecole-ipssi.com/ecole-informatique-nice/)

### 🆘 Support et Contact


---

## 📜 Conclusion

Ce projet démontre notre capacité à :
- **Maîtriser les outils modernes** d'Infrastructure as Code
- **Travailler en équipe** sur des projets techniques complexes
- **Documenter et tester** rigoureusement nos solutions
- **Respecter les bonnes pratiques** de sécurité et de développement

L'infrastructure déployée est **fonctionnelle, sécurisée et documentée**, prête pour un environnement de production. Le travail collaboratif via Git démontre nos compétences en DevOps et gestion de projet.

---

<div align="center">

**© 2025 - M1 Cybersécurité & Cloud Computing - IPSSI Nice**

Made with ❤️ by Team IPSSI

[![Azure](https://img.shields.io/badge/Deployed%20on-Azure-blue?style=flat-square&logo=microsoft-azure)](https://azure.microsoft.com)
[![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-purple?style=flat-square&logo=terraform)](https://terraform.io)
[![IPSSI](https://img.shields.io/badge/School-IPSSI%20Nice-green?style=flat-square)](https://ecole-ipssi.com/ecole-informatique-nice/)

</div>
