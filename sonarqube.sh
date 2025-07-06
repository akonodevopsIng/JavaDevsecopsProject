#!/bin/bash

# Script d'installation de SonarQube avec Docker
# Usage: sudo ./install_sonarqube_docker.sh

set -e  # Arrêter le script en cas d'erreur

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez l'installer avant d'exécuter ce script."
    exit 1
fi

echo "=== Démarrage de l'installation SonarQube avec Docker ==="

# 1. Lancer le conteneur PostgreSQL
echo "[1/3] Lancement de PostgreSQL..."
docker run -d --name postgres-sonar \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD=sonar \
  -e POSTGRES_DB=sonarqube \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:13

# 2. Configurer la mémoire virtuelle (requis pour Elasticsearch)
echo "[2/3] Configuration de la mémoire virtuelle..."
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# 3. Lancer le conteneur SonarQube
echo "[3/3] Lancement de SonarQube..."
docker run -d --name sonarqube \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://postgres-sonar:5432/sonarqube \
  -e SONAR_JDBC_USERNAME=sonar \
  -e SONAR_JDBC_PASSWORD=sonar \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  --link postgres-sonar \
  sonarqube:lts-community

echo ""
echo "=== Installation terminée avec succès ==="
echo "Accédez à SonarQube via: http://localhost:9000"
echo "Identifiants par défaut: admin/admin"
echo ""
echo "Pour surveiller les logs:"
echo "  docker logs sonarqube"
echo ""
echo "Pour arrêter les conteneurs:"
echo "  docker stop sonarqube postgres-sonar"
echo ""
echo "Pour redémarrer:"
echo "  docker start postgres-sonar sonarqube"
