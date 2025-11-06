#!/bin/bash
###############################################################################
# NextGen Farmers Hub - AWS EC2 Bootstrap Script
# This script sets up Docker and required dependencies on a fresh Ubuntu instance
###############################################################################

set -e

echo "=========================================="
echo "NextGen Farmers Hub - AWS Bootstrap"
echo "=========================================="

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    exit 1
fi

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    git \
    wget \
    vim \
    htop \
    unzip \
    jq

# Install Docker
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker installed successfully"
else
    echo "Docker is already installed"
fi

# Install Docker Compose
echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully"
else
    echo "Docker Compose is already installed"
fi

# Install AWS CLI
echo "Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    echo "AWS CLI installed successfully"
else
    echo "AWS CLI is already installed"
fi

# Setup firewall (UFW)
echo "Configuring firewall..."
if ! sudo ufw status | grep -q "Status: active"; then
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 22/tcp comment "SSH"
    sudo ufw allow 80/tcp comment "HTTP"
    sudo ufw allow 443/tcp comment "HTTPS"
    sudo ufw --force enable
    echo "Firewall configured successfully"
else
    echo "Firewall is already configured"
fi

# Create directories
echo "Creating application directories..."
mkdir -p ~/nextgen_farmers
mkdir -p ~/backups
mkdir -p ~/logs

# Configure log rotation
echo "Setting up log rotation..."
sudo tee /etc/logrotate.d/nextgen-farmers > /dev/null <<EOF
/home/$USER/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    missingok
    create 0640 $USER $USER
}
EOF

# Install CloudWatch agent (optional)
read -p "Do you want to install CloudWatch agent? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing CloudWatch agent..."
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    sudo dpkg -i amazon-cloudwatch-agent.deb
    rm amazon-cloudwatch-agent.deb
    echo "CloudWatch agent installed. Run configuration wizard: sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard"
fi

# Display versions
echo ""
echo "=========================================="
echo "Installation Summary"
echo "=========================================="
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "AWS CLI version: $(aws --version)"
echo ""
echo "=========================================="
echo "Bootstrap completed successfully!"
echo "=========================================="
echo ""
echo "IMPORTANT: You need to log out and log back in for Docker group changes to take effect."
echo ""
echo "Next steps:"
echo "1. Log out: exit"
echo "2. SSH back in"
echo "3. Clone repository: cd ~/nextgen_farmers && git clone https://github.com/your-org/nextgen_farmers.git ."
echo "4. Configure environment: cp .env.example .env && nano .env"
echo "5. Start services: docker-compose up -d"
echo ""
