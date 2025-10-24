# easyTrade on AWS EC2 Setup Guide

This guide shows how to deploy the Dynatrace easyTrade demo application on an AWS EC2 instance.

> **Current Status**: ✅ **ACTIVE DEPLOYMENT** - easyTrade running at http://3.16.217.113:80
> 
> Check [AmazonQ.md](./AmazonQ.md) for the latest deployment status and context information.

## About easyTrade

easyTrade is a microservices-based stock trading application consisting of 19 interconnected services. It showcases:
- Distributed tracing across microservices
- Business event capture and analysis
- Built-in problem patterns for demonstration
- Modern cloud-native architecture patterns

## Prerequisites

- AWS account with EC2 access
- Basic knowledge of AWS EC2 and security groups
- Understanding of Docker and microservices

## EC2 Instance Requirements

- **Instance Type**: t3.large or larger (minimum 8GB RAM for 19 services)
- **Recommended**: t3.xlarge for stable performance
- **Operating System**: Amazon Linux 2 or Ubuntu
- **Storage**: 30GB minimum (50GB recommended)

## Security Group Configuration

Create or modify your security group to allow inbound traffic on these ports:

| Port | Protocol | Source | Description |
|------|----------|---------|-------------|
| 22   | TCP      | Your IP | SSH access |
| 80   | TCP      | 0.0.0.0/0 | Main application |

## Installation Steps

### 1. Launch EC2 Instance
- Choose Amazon Linux 2 AMI
- Select t3.large or larger
- Configure security group as above
- Launch with your key pair

### 2. Connect to Instance
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 3. Install Docker (v20.10.13+)
```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 4. Install Docker Compose Plugin
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Or install via package manager (Ubuntu)
sudo apt update
sudo apt install docker-compose-plugin
```

### 5. Install Git (Amazon Linux 2 only)
```bash
sudo yum install git -y
```

### 6. Install Dynatrace OneAgent (CRITICAL - Before Containers)

**Important**: Install OneAgent BEFORE deploying containers for full monitoring coverage.

```bash
# Download OneAgent installer (replace with your credentials)
wget -O Dynatrace-OneAgent-Linux-x86.sh "https://YOUR_ENVIRONMENT_URL/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token YOUR_API_TOKEN"

# Make executable and install
chmod +x Dynatrace-OneAgent-Linux-x86.sh
sudo ./Dynatrace-OneAgent-Linux-x86.sh

# Verify installation
sudo systemctl status oneagent
```

### 7. Logout and Login Again
```bash
exit
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 8. Deploy easyTrade
```bash
git clone https://github.com/Dynatrace/easytrade.git
cd easytrade
docker compose up -d
```

### 9. Setup Autostart (Optional but Recommended)

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

### 10. Verify Deployment
```bash
docker compose ps
```

All 19 services should show "Up" status. This takes approximately **3-5 minutes** (faster than initially estimated).

## Access the Application

Once deployed, access the application using your EC2 public IP:

- **Main Application**: `http://YOUR_EC2_PUBLIC_IP:80`

## Default Users

You can login with these pre-configured users:

| Username | Password | Notes |
|----------|----------|-------|
| demouser | demopass | Basic demo user |
| specialuser | specialpass | Special demo user |
| james_norton | pass_james_123 | Has pre-populated trading data |

> **Note**: After creating a new user, there's no confirmation. Just return to the login page and try logging in.

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
