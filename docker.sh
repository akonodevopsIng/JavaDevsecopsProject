#!/bin/bash

# Script d'installation automatique de Docker sur Ubuntu

set -e

echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "Suppression d’anciennes versions éventuelles de Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

echo "Installation des paquets nécessaires..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release

echo "Ajout de la clé GPG officielle de Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Ajout du dépôt Docker au sources.list..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Mise à jour de la liste des paquets..."
sudo apt update

echo "Installation de Docker Engine, Docker CLI et containerd..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "Vérification du statut du service Docker :"
sudo systemctl status docker --no-pager | grep Active

echo "Test de Docker avec l'image hello-world..."
sudo docker run hello-world

echo "Ajout de l'utilisateur actuel au groupe docker (pour exécuter docker sans sudo)..."
sudo usermod -aG docker $USER

echo "--------------------------------------------"
echo "Installation de Docker terminée !"
echo "Déconnectez-vous puis reconnectez-vous pour utiliser Docker sans sudo."
echo "Vous pouvez tester avec : docker run hello-world"
echo "--------------------------------------------"
