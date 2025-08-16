#!/bin/bash

# Script zum Installieren von Docker & Docker Compose
# und zum Hinzufügen des aktuellen Users zur Docker-Gruppe

set -e

echo "=== Update Paketquellen ==="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "=== Docker installieren ==="
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker GPG Key hinzufügen
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker Repo hinzufügen
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker installieren
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Docker Compose installieren ==="
sudo apt-get install -y docker-compose

echo "=== User zu Docker-Gruppe hinzufügen ==="
sudo groupadd docker || true
sudo usermod -aG docker $USER

echo "=== Installation abgeschlossen! ==="
echo "Bitte abmelden oder 'newgrp docker' ausführen, damit die Änderungen aktiv werden."
