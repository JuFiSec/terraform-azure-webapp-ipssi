#!/bin/bash
# Script d'installation du serveur web
# Responsable : FIENI DANNIE INNOCENT JUNIOR

# Mise à jour du système
apt-get update -y
apt-get upgrade -y

# Installation d'Apache2, PHP et modules nécessaires
apt-get install -y apache2 php php-mysql php-curl php-json php-xml php-mbstring
apt-get install -y mysql-client curl wget git

# Activation et démarrage d'Apache
systemctl enable apache2
systemctl start apache2

# Configuration du pare-feu
ufw allow 'Apache Full'
ufw allow OpenSSH
ufw --force enable

# Création d'une page de test PHP
cat > /var/www/html/index.php << 'ENDPHP'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TP Terraform - IPSSI Nice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .info-box {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            margin: 15px 0;
            border-radius: 10px;
            border-left: 5px solid #ffd700;
        }
        .success {
            border-left-color: #4CAF50;
        }
        .team-member {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 Infrastructure Web Déployée avec Succès!</h1>
            <h2>TP Terraform - M1 Cybersécurité & Cloud Computing</h2>
            <h3>IPSSI Nice</h3>
        </div>
        
        <div class="info-box success">
            <h3>✅ Serveur Web Actif</h3>
            <p><strong>Serveur:</strong> Apache <?php echo apache_get_version(); ?></p>
            <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
            <p><strong>Système:</strong> <?php echo php_uname('s') . ' ' . php_uname('r'); ?></p>
            <p><strong>Date de déploiement:</strong> <?php echo date('d/m/Y H:i:s'); ?></p>
        </div>

        <div class="info-box">
            <h3>👥 Équipe de Développement</h3>
            <div class="team-member">
                <strong>👨‍💼 Chef de Projet:</strong><br>
                FIENI DANNIE INNOCENT JUNIOR
            </div>
            <div class="team-member">
                <strong>🌐 Responsable Réseau:</strong><br>
                Kaouthar Brazi
            </div>
            <div class="team-member">
                <strong>🗄️ Responsable Base de Données:</strong><br>
                Amine Karassane
            </div>
        </div>

        <div class="info-box">
            <h3>🏗️ Architecture Déployée</h3>
            <ul>
                <li>✅ Réseau Virtuel Azure (VNet)</li>
                <li>✅ Machine Virtuelle Linux Ubuntu 22.04</li>
                <li>✅ Serveur Web Apache + PHP</li>
                <li>✅ Base de Données MySQL</li>
                <li>✅ Stockage Azure</li>
                <li>✅ Sécurité Réseau (NSG)</li>
                <li>✅ IP Publique</li>
            </ul>
        </div>

        <div class="info-box">
            <h3>🔧 Informations Techniques</h3>
            <p><strong>Hostname:</strong> <?php echo gethostname(); ?></p>
            <p><strong>IP Locale:</strong> <?php echo $_SERVER['SERVER_ADDR']; ?></p>
        </div>

        <?php
        $mysql_host = "${mysql_server}";
        $mysql_db = "${db_name}";
        
        if (!empty($mysql_host)) {
            echo '<div class="info-box">';
            echo '<h3>🗄️ État de la Base de Données</h3>';
            echo "<p><strong>Serveur MySQL:</strong> $mysql_host</p>";
            echo "<p><strong>Base de données:</strong> $mysql_db</p>";
            echo "<p>✅ Configuration MySQL disponible</p>";
            echo '</div>';
        }
        ?>

        <div class="info-box">
            <h3>📚 Technologies Utilisées</h3>
            <p>
                <strong>Infrastructure:</strong> Terraform + Azure<br>
                <strong>Web:</strong> Apache + PHP<br>
                <strong>Base de données:</strong> MySQL<br>
                <strong>OS:</strong> Ubuntu 22.04 LTS<br>
                <strong>Versionning:</strong> Git + GitHub
            </p>
        </div>
    </div>
</body>
</html>
ENDPHP

# Configuration d'Apache pour utiliser index.php par défaut
rm -f /var/www/html/index.html
echo "DirectoryIndex index.php index.html" >> /etc/apache2/sites-available/000-default.conf

# Redémarrage d'Apache
systemctl restart apache2

# Logs pour le débogage
echo "$(date): Installation du serveur web terminée" >> /var/log/installation.log

# Installation de certains outils utiles pour le monitoring
apt-get install -y htop iotop nethogs

echo "Installation terminée avec succès!" >> /var/log/installation.log
