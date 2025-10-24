# 🚀 easyTrade on AWS: Your Microservices Trading Empire

Welcome to the ultimate stock trading demo! Deploy 19 interconnected microservices and watch distributed tracing magic happen in real-time. 📈

> **🎯 Current Status**: Check [AmazonQ.md](./AmazonQ.md) for live deployment info!

## 🎭 Meet easyTrade: The Star of the Show

Imagine a bustling stock exchange with 19 different departments working together seamlessly. That's easyTrade! This isn't just another demo app - it's a **microservices masterpiece** that showcases:

- 🕸️ **Distributed tracing** across 19 services (yes, nineteen!)
- 📊 **Business event capture** - see every trade, every click, every decision
- 💥 **Built-in chaos** - 4 problem patterns to break things beautifully
- ☁️ **Cloud-native architecture** that would make any DevOps engineer proud

## 🎒 What You'll Need

- 🔑 AWS account with EC2 superpowers
- 🧠 Basic knowledge of AWS EC2 and security groups
- 🐳 Understanding of Docker and microservices magic

## 💪 EC2 Power Requirements

Your trading empire needs proper infrastructure! Here's what works:

- **🏆 Proven Champion**: t3.large (2 vCPU, 8GB RAM) - handles all 19 services like a boss!
- **⚡ Only upgrade if needed**: t3.xlarge for extra muscle (if you see performance issues)
- **🖥️ Operating System**: Amazon Linux 2 or Ubuntu (your choice!)
- **💾 Storage**: 30GB minimum (50GB for comfort zone)

> **💡 Pro Tip**: We've successfully run this on t3.large - it's faster than expected at just 3 minutes startup!

## 🔐 Security Group: Your Digital Fortress

Create or modify your security group to allow inbound traffic on these ports:

| Port | Protocol | Source | Description | Status |
|------|----------|---------|-------------|---------|
| 22   | TCP      | Your IP | SSH access | 🔑 Essential |
| 80   | TCP      | 0.0.0.0/0 | Main application | 🌐 Public |

## 🚀 Let's Get This Trading Floor Running!

### 1. 🏗️ Launch Your EC2 Trading Hub
- Choose Amazon Linux 2 AMI (it's reliable!)
- Select t3.large or larger (trust us on this one)
- Configure security group as above
- Launch with your key pair

### 2. 🔌 Connect to Your Instance
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 3. 🐳 Install Docker (The Container Magic)
```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 4. 🔧 Install Docker Compose Plugin (The Orchestrator)
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Or install via package manager (Ubuntu)
sudo apt update
sudo apt install docker-compose-plugin
```

### 5. 📦 Install Git (Amazon Linux 2 only)
```bash
sudo yum install git -y
```

### 6. 👁️ Install Dynatrace OneAgent (The All-Seeing Eye)

**🚨 Critical**: Install OneAgent BEFORE deploying containers for full monitoring coverage!

```bash
# Download OneAgent installer (replace with your credentials)
wget -O Dynatrace-OneAgent-Linux-x86.sh "https://YOUR_ENVIRONMENT_URL/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token YOUR_API_TOKEN"

# Make executable and install
chmod +x Dynatrace-OneAgent-Linux-x86.sh
sudo ./Dynatrace-OneAgent-Linux-x86.sh

# Verify installation
sudo systemctl status oneagent
```

### 7. 🔄 Logout and Login Again (Trust the Process)
```bash
exit
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 8. 🎯 Deploy easyTrade (The Main Event!)
```bash
git clone https://github.com/Dynatrace/easytrade.git
cd easytrade
docker compose up -d
```

### 9. 🔄 Setup Autostart (Because Nobody Likes Manual Restarts)

Configure easyTrade to start automatically after reboot:

```bash
# Create systemd service file
sudo tee /etc/systemd/system/easytrade-autostart.service > /dev/null <<EOF
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

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable easytrade-autostart.service
sudo systemctl start easytrade-autostart.service
```

### 10. ✅ Verify Your Trading Empire is Live
```bash
docker compose ps
```

All 19 services should show "Up" status. This takes approximately **3-5 minutes** (faster than initially estimated). ⚡

## 🎉 Access Your Trading Empire

Once deployed, access the application using your EC2 public IP:

- **🌟 Main Application**: `http://YOUR_EC2_PUBLIC_IP:80`

## 👥 Meet Your Traders (Default Users)

You can login with these pre-configured users:

| Username | Password | Notes | 🎭 |
|----------|----------|-------|-----|
| demouser | demopass | Basic demo user | 👤 |
| specialuser | specialpass | Special demo user | ⭐ |
| james_norton | pass_james_123 | Has pre-populated trading data | 💰 |

> **💡 Pro Tip**: After creating a new user, there's no confirmation. Just return to the login page and try logging in!

## Application Services

easyTrade consists of 19 microservices:

| Service | Description | Endpoint |
|---------|-------------|----------|
| Frontend | React trading interface | `/` |
| Account Service | User account management | `/accountservice` |
| Broker Service | Trading operations | `/broker-service` |
| Pricing Service | Stock price management | `/pricing-service` |
| Login Service | Authentication | `/loginservice` |
| Manager | Trade management | `/manager` |
| Engine | Trading engine | `/engine` |
| Feature Flag Service | Problem pattern control | `/feature-flag-service` |
| Credit Card Service | Payment processing | `/credit-card-order-service` |
| Third Party Service | External integrations | `/third-party-service` |
| Offer Service | Stock offers | `/offerservice` |
| Database | SQL Server | Internal |
| RabbitMQ | Message queue | Internal |
| Load Generator | Traffic generation | Internal |
| And 5 more services... | Various functions | Internal |

## Problem Patterns

easyTrade includes 4 built-in problem patterns for demonstration:

1. **DbNotResponding**: Database becomes unresponsive, blocking new trades
2. **ErgoAggregatorSlowdown**: Aggregator services experience slowdown
3. **FactoryCrisis**: Credit card factory stops producing cards
4. **HighCpuUsage**: Broker service experiences high CPU usage

### Enable Problem Patterns

Via API:
```bash
curl -X PUT "http://YOUR_EC2_PUBLIC_IP/feature-flag-service/v1/flags/DbNotResponding/" \
-H "accept: application/json" \
-d '{"enabled": true}'
```

Or use the frontend interface to manage problem patterns.

## Useful Commands

### View logs for all services
```bash
docker compose logs -f
```

### View logs for specific service
```bash
docker compose logs -f frontend
```

### Stop application
```bash
docker compose down
```

### Restart application
```bash
docker compose restart
```

### Update images
```bash
docker compose pull
docker compose up -d
```

## Troubleshooting

### Check if application is accessible
```bash
curl -I http://localhost:80
```

### Check container status
```bash
docker compose ps
```

### View container logs
```bash
docker compose logs [service_name]
```

### Check resource usage
```bash
docker stats
```

### Free up disk space
```bash
docker system prune -a
```

## Performance Notes

- **Startup Time**: Allow 3-5 minutes for all 19 services to stabilize (faster than expected)
- **Memory Usage**: Expect 6-8GB RAM usage with all services running
- **CPU Usage**: Moderate CPU usage across multiple cores
- **Storage**: Monitor disk space as logs can accumulate

## Cost Optimization

- Use **t3.large minimum** for stable operation
- **Stop instance** when not in use to save costs
- Consider **Spot instances** for temporary demos
- Use **Elastic IP** if you need consistent access
- Monitor **CloudWatch** for resource usage

## Security Notes

- Restrict security group sources to your IP when possible
- Consider using **Application Load Balancer** for production-like setups
- Monitor CloudWatch for resource usage
- Set up **CloudWatch alarms** for cost control

## Next Steps

1. Install Dynatrace OneAgent on the EC2 instance
2. Configure monitoring in your Dynatrace tenant
3. Explore the built-in problem patterns
4. Generate load and observe distributed tracing
5. Configure business event capture rules

## Cleanup

### Option 1: Shutdown Instance (Preserve for Later Use)

For temporary shutdown while keeping all configuration:

```bash
# Stop the instance (preserves everything)
aws ec2 stop-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID

# To restart later
aws ec2 start-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID
```

**Benefits**: No redeployment needed (saves 3-5 minutes for 19 services), faster restart, keeps all configuration.
**Note**: Public IP changes after stop/start.

### Option 2: Complete Cleanup (Permanent Removal)

When you're done with the demo permanently:

1. **Terminate EC2 instance**: `aws ec2 terminate-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID`
2. **Delete key pair**: `aws ec2 delete-key-pair --region us-east-2 --key-name easytrade-key`
3. **Remove local PEM file**: `rm -f easytrade-key.pem`
4. **Delete custom security groups** (if any were created)

Always terminate instances first to stop charges immediately.

---

**Repository**: https://github.com/Dynatrace/easytrade
**Architecture**: 19 microservices with distributed tracing
**Use Case**: Stock trading application for Dynatrace demonstrations
**Context**: See [AmazonQ.md](./AmazonQ.md) for current deployment status
