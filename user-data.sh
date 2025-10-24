#!/bin/bash
yum update -y

# Install Docker
yum install -y docker git
service docker start
usermod -a -G docker ec2-user

# Install Docker Compose Plugin
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create symlink for docker compose plugin
mkdir -p /usr/local/lib/docker/cli-plugins
ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Clone easyTrade repository
cd /home/ec2-user
git clone https://github.com/Dynatrace/easytrade.git
chown -R ec2-user:ec2-user /home/ec2-user/easytrade

# Create systemd service for autostart
cat > /etc/systemd/system/easytrade-autostart.service << 'EOF'
[Unit]
Description=easyTrade Docker Compose Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/ec2-user/easytrade
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0
User=ec2-user
Group=docker

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl daemon-reload
systemctl enable easytrade-autostart.service

# Start easyTrade (will run as ec2-user via systemd)
systemctl start easytrade-autostart.service
