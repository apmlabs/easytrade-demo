# 🚀 easyTrade on AWS: Your Kubernetes Microservices Trading Empire

Welcome to the ultimate stock trading demo! Deploy 19 interconnected microservices on Kubernetes (k3s) and watch distributed tracing magic happen in real-time. 📈

> **🎯 Current Status**: Check [AmazonQ.md](./AmazonQ.md) for live deployment info!

## 🎭 Meet easyTrade: The Star of the Show

Imagine a bustling stock exchange with 19 different departments working together seamlessly. That's easyTrade! This isn't just another demo app - it's a **microservices masterpiece** that showcases:

- 🕸️ **Distributed tracing** across 19 services (yes, nineteen!)
- 📊 **Business event capture** - see every trade, every click, every decision
- 💥 **Built-in chaos** - 4 problem patterns to break things beautifully
- ☁️ **Cloud-native architecture** running on Kubernetes (k3s)
- 🎯 **Production-ready** with proper resource limits and health checks

## 🎒 What You'll Need

- 🔑 AWS account with EC2 superpowers
- 🧠 Basic knowledge of AWS EC2 and security groups
- ☸️ Understanding of Kubernetes concepts (pods, services, deployments)
- 🐳 Basic Docker knowledge for container concepts

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
| 6443 | TCP      | Your IP | k3s API server | ⚙️ Optional |

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

### 3. ☸️ Install k3s (The Kubernetes Magic)
```bash
# Install k3s single-node cluster
curl -sfL https://get.k3s.io | sh -

# Configure kubectl access
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Verify cluster is ready
kubectl get nodes
```

### 4. 📦 Install Git (Amazon Linux 2 only)
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

# Deploy using Kubernetes manifests
kubectl apply -k kubernetes-manifests/base/

# Wait for all pods to be ready (this takes 5-7 minutes)
kubectl wait --for=condition=ready pod --all --timeout=600s
```

### 9. ✅ Verify Your Trading Empire is Live
```bash
kubectl get pods -o wide
kubectl get services
```

All 19 pods should show "Running" status. This takes approximately **5-7 minutes** for full stabilization. ⚡

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

## 🚨 Problem Patterns Available (All Currently Disabled)

| Pattern | ID | Status | Effect |
|---------|----|---------| -------|
| DB Not Responding | `db_not_responding` | ❌ OFF | Blocks new trades |
| Aggregator Slowdown | `ergo_aggregator_slowdown` | ❌ OFF | Service delays |
| Factory Crisis | `factory_crisis` | ❌ OFF | Credit card processing blocked |
| High CPU Usage | `high_cpu_usage` | ❌ OFF | Performance degradation |
| Credit Card Meltdown | `credit_card_meltdown` | ❌ OFF | Frontend errors |

### Enable Problem Patterns:
```bash
curl -X PUT "http://YOUR_EC2_PUBLIC_IP/feature-flag-service/v1/flags/{PATTERN_ID}/" \
-H "accept: application/json" \
-d '{"enabled": true}'
```

## 🎯 Load Generation Active
- **5 concurrent workers** running realistic scenarios
- **Traffic patterns**: order_credit_card, deposit_and_buy_success, etc.
- **Synthetic users**: Realistic profiles with IP addresses
- **Browser simulation**: Headless browsers for authentic interactions

## 👥 Default Users
- demouser/demopass
- specialuser/specialpass
- james_norton/pass_james_123 (has pre-populated trading data)

## 🔧 Management Commands

### Check Status:
```bash
# All containers
kubectl get pods -o wide

# Feature flags
curl http://YOUR_EC2_PUBLIC_IP/feature-flag-service/v1/flags
```

### Infrastructure Control:
```bash
# Stop instance (preserve config)
aws ec2 stop-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID

# Start instance (get new IP)
aws ec2 start-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID
```

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
kubectl logs -f deployment/frontend
```

### View logs for specific service
```bash
kubectl logs -f deployment/broker-service
```

### Stop application
```bash
kubectl delete -k kubernetes-manifests/base/
```

### Restart application
```bash
kubectl rollout restart deployment/frontend
```

### Update images
```bash
kubectl rollout restart deployment --all
```

## Troubleshooting

### Check if application is accessible
```bash
curl -I http://localhost:80
```

### Check container status
```bash
kubectl get pods -o wide
```

### View container logs
```bash
kubectl logs deployment/SERVICE_NAME
```

### Check resource usage
```bash
kubectl top nodes
kubectl top pods
```

### Free up disk space
```bash
kubectl delete pods --field-selector=status.phase=Succeeded
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
