
#!/bin/bash
set -e

echo "=================================="
echo "       JENKINS INSTALLATION"
echo "=================================="

# Update Ubuntu
echo "Updating Ubuntu..."
sudo apt update
sudo apt upgrade -y

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y fontconfig openjdk-21-jre wget curl

# Verify Java
echo "Checking Java..."
java -version

# Add Jenkins GPG key
echo "Adding Jenkins repository key..."
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add Jenkins repository
echo "Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list
sudo apt update

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install -y jenkins

# Enable and start Jenkins
echo "Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Display status
echo "Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

# Display initial password
echo "=================================="
echo "JENKINS INITIAL ADMIN PASSWORD"
echo "=================================="

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "=================================="
echo "JENKINS INSTALLATION COMPLETED"
echo "=================================="
echo "Access Jenkins at: http://YOUR_SERVER_PUBLIC_IP:8080"

