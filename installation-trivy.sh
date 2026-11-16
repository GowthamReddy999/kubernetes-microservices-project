#!/bin/bash

set -e

echo "Installing Trivy..."

# Update packages
sudo apt-get update

# Install dependencies
sudo apt-get install -y wget gnupg

# Add Trivy GPG key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

# Add official Trivy repository
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list

# Install Trivy
sudo apt-get update
sudo apt-get install -y trivy

# Verify installation
echo "Trivy installation completed!"
trivy --version
