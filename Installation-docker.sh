
#!/bin/bash
set -e

echo "===== Updating Ubuntu ====="
sudo apt update
sudo apt upgrade -y

echo "===== Installing dependencies ====="
sudo apt install -y ca-certificates curl

echo "===== Adding Docker GPG key ====="
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "===== Adding Docker repository ====="

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "===== Installing Docker Engine ====="

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "===== Enabling Docker ====="

sudo systemctl enable docker
sudo systemctl start docker

echo "===== Adding current user to Docker group ====="

sudo usermod -aG docker "$USER"

echo "===== Checking Docker ====="

sudo docker --version
sudo docker compose version
sudo systemctl status docker --no-pager

echo "===== Docker installation completed ====="
echo "Log out and log back in to use Docker without sudo."

