#!/bin/bash

# Install Trivy on Ubuntu (Standalone Binary)
# Author: Your Name
# Usage: sudo ./install_trivy.sh

set -e  # Exit on error

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root (use sudo)."
  exit 1
fi

echo "=== Installing Trivy ==="

# Step 1: Install dependencies
echo "[1/4] Installing dependencies..."
apt update -qq && apt install -y -qq wget apt-transport-https gnupg lsb-release

# Step 2: Add Trivy repository
echo "[2/4] Adding Trivy repository..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/trivy.list

# Step 3: Install Trivy
echo "[3/4] Installing Trivy..."
apt update -qq && apt install -y -qq trivy

# Step 4: Verify installation
echo "[4/4] Verifying installation..."
trivy --version

echo ""
echo "=== Trivy installed successfully! ==="
echo "Usage examples:"
echo "  Scan a Docker image:    trivy image ubuntu:latest"
echo "  Scan a directory:      trivy fs --security-checks vuln /path/to/dir"
echo "  Scan for secrets:      trivy fs --security-checks secret /path/to/code"
