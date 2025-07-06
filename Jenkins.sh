#!/bin/bash

# Script d'installation automatique de Jenkins sur Ubuntu Server

set -e

echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "Installation de Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

echo "Ajout de la clé et du dépôt Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Mise à jour des paquets (prise en compte du dépôt Jenkins)..."
sudo apt update

echo "Installation de Jenkins..."
sudo apt install -y jenkins

echo "Démarrage et activation du service Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Ouverture du port 8080 sur le pare-feu (ufw)..."
sudo ufw allow 8080
sudo ufw reload

echo "Installation terminée !"
echo "--------------------------------------------"
echo "Vérifiez le statut de Jenkins :"
sudo systemctl status jenkins | grep Active
echo "--------------------------------------------"
echo "Mot de passe initial d'administration Jenkins (copiez-le pour l'interface web) :"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "--------------------------------------------"
echo "Accédez à Jenkins sur : http://$(hostname -I | awk '{print $1}'):8080"
