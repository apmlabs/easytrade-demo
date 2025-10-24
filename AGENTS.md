# easyTrade Deployment Agent Context

You are an agent that helps deploy and troubleshoot easyTrade demo application on AWS EC2.

Repository URL: https://github.com/Dynatrace/easytrade

## Deployment Information
- easyTrade is a microservices-based stock trading demo application developed by Dynatrace
- Consists of 19 interconnected services showcasing distributed tracing and monitoring
- Supports deployment on AWS EC2 instances with Docker Compose or Kubernetes
- Official repository: https://github.com/Dynatrace/easytrade
- Modern cloud-native application with built-in problem patterns for demonstration

## Application Architecture
easyTrade consists of 19 microservices:
- **Frontend**: React-based trading interface
- **Backend Services**: Account, Broker, Pricing, Login, Manager, Engine services
- **Database**: SQL Server with pre-populated trading data
- **Message Queue**: RabbitMQ for async communication
- **Load Generator**: Built-in synthetic traffic generation
- **Problem Patterns**: 4 configurable problem scenarios for demonstration

## EC2 Instance Requirements
- **Minimum**: t3.large (2 vCPU, 8GB RAM) - due to 19 microservices
- **Recommended**: t3.xlarge for stable performance
- **Storage**: 30GB minimum (50GB recommended)
- **OS**: Amazon Linux 2 or Ubuntu 20.04/22.04
- **Ports**: 22 (SSH), 80 (main application)

## Deployment Strategy
- Local system is CONTROL CENTER only - deploy easyTrade on remote EC2 instance
- Use SSH access with PEM key for remote deployment
- Security group must allow required ports for application access
- Docker and Docker Compose Plugin required on target instance
- **CRITICAL**: Install Dynatrace OneAgent BEFORE deploying easyTrade containers

## Installation Process (CRITICAL: OneAgent FIRST)
1. **EC2 Setup**: Launch instance with proper security group
2. **Docker Installation**: Install Docker and Docker Compose Plugin (v20.10.13+)
3. **Git Installation**: Install git (required for Amazon Linux 2)
4. **Dynatrace OneAgent**: **CRITICAL - INSTALL FIRST** - Use credentials from secrets.yaml
5. **Repository Clone**: Clone easyTrade repository
6. **Container Deployment**: Run `docker compose up -d`
7. **Autostart Setup**: Configure systemd service for automatic restart
8. **Verification**: Check container status and application accessibility

**DEPLOYMENT TIMING**: Actual deployment takes ~3 minutes (much faster than estimated 10-15 minutes)
- User data script is highly efficient
- Docker pulls and container startup are optimized
- All 19 services start in parallel effectively

**CRITICAL INSTALLATION ORDER**: OneAgent MUST be installed BEFORE containers start
- OneAgent auto-discovers and monitors all 19 microservices
- Installing after containers requires container restart for full monitoring
- Post-deployment OneAgent installation confirmed working on active easyTrade instance

## Docker Requirements
- **Docker**: Minimum version v20.10.13
- **Docker Compose Plugin**: Required (NOT docker-compose v1)
- **Installation**:
```bash
# Amazon Linux 2
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Docker Compose Plugin
sudo apt update
sudo apt install docker-compose-plugin
```

## Dynatrace OneAgent Installation
- **Credentials**: Stored in secrets.yaml (environment URL and API token)
- **Installation Order**: MUST be installed BEFORE easyTrade containers
- **Process**:
  1. Download installer: `wget -O Dynatrace-OneAgent-Linux-x86-*.sh "{url}/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token {token}"`
  2. Make executable: `chmod +x Dynatrace-OneAgent-Linux-x86-*.sh`
  3. Install: `sudo ./Dynatrace-OneAgent-Linux-x86-*.sh`
  4. Verify: `sudo systemctl status oneagent`
- **Auto-discovery**: OneAgent automatically discovers and monitors all 19 microservices

## Security Group Configuration
- Port 22: SSH access (restrict to your IP)
- Port 80: Main application (0.0.0.0/0 or restricted)

## Application Access
- **Main Application**: `http://YOUR_EC2_PUBLIC_IP:80`
- **Default Users**:
  - `demouser/demopass`
  - `specialuser/specialpass`
  - `james_norton/pass_james_123` (has pre-populated data)

## Problem Patterns
easyTrade includes 4 built-in problem patterns for demonstration:
1. **DbNotResponding**: Database errors preventing new trades
2. **ErgoAggregatorSlowdown**: Aggregator service slowdown
3. **FactoryCrisis**: Credit card processing issues
4. **HighCpuUsage**: CPU throttling and response time issues

Enable via API or frontend interface.

## Learning Objectives
- Understand microservices architecture and distributed tracing
- Learn container orchestration with 19+ services
- Practice Dynatrace monitoring setup and configuration
- Explore business event capture and analysis
- Gain experience with problem pattern simulation
- Study service mesh communication patterns

## Rules
- Always update AGENTS.md when discovering new deployment insights
- **Current status is in AmazonQ.md context** - check existing deployment before creating new infrastructure
- Use AWS CLI to verify resources before creating new ones
- Document any deployment issues and their solutions
- Test application accessibility after deployment
- **Default Infrastructure Behavior**: Check AmazonQ.md first - only create new infrastructure if none exists
- **Default Region**: Use us-east-2 unless otherwise specified
- **Status Reporting**: Current deployment status is always available in AmazonQ.md context

## GitHub Repository Setup

### Creating Private Repository with Protected Secrets
When creating a GitHub repository from the project folder:

1. **Create .gitignore first**:
```bash
cat > .gitignore << 'EOF'
# Sensitive files
secrets.yaml
*.pem
*.key

# AWS credentials
.aws/
aws-credentials*

# Environment files
.env
.env.local
.env.production

# Logs and temporary files
*.log
logs/
*.tmp
*.temp
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
EOF
```

2. **Initialize and commit**:
```bash
git init
git add .
git commit -m "Initial commit: easyTrade AWS deployment scripts and documentation"
```

3. **Create private repository**:
   - **CLI method**: `gh repo create easytrade-demo --private --description "easyTrade deployment scripts"`
   - **Manual method**: GitHub.com → New → Private → Don't initialize with README

4. **Push code**:
```bash
git remote add origin https://github.com/USERNAME/easytrade-demo.git
git push -u origin main
```

## Cleanup Strategy

### Option 1: Shutdown Instance (Preserve Infrastructure)
For temporary shutdown while preserving all infrastructure and configuration:

```bash
# Stop the EC2 instance (preserves all data and configuration)
aws ec2 stop-instances --region us-east-2 --instance-ids INSTANCE_ID

# Verify instance is stopped
aws ec2 describe-instances --region us-east-2 --instance-ids INSTANCE_ID --query "Reservations[].Instances[].[InstanceId,State.Name]" --output table
```

**To restart later:**
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids INSTANCE_ID

# Get new public IP (changes after stop/start)
aws ec2 describe-instances --region us-east-2 --instance-ids INSTANCE_ID --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```

**Benefits:**
- Preserves all configuration and data
- No redeployment needed (saves 10-15 minutes for 19 services)
- Faster restart (2-3 minutes vs full deployment time)
- Keeps same instance ID and security group
- easyTrade autostart service will restart all 19 containers automatically

**Note:** Public IP changes after stop/start, but all configuration remains intact.

### Option 2: Complete Infrastructure Cleanup
When cleaning up easyTrade deployments permanently, follow this order to avoid dependency issues:

1. **Terminate EC2 Instances**
   ```bash
   # List instances first
   aws ec2 describe-instances --region us-east-2 --filters "Name=tag:Name,Values=easyTrade*" --query "Reservations[].Instances[].[InstanceId,Tags[?Key=='Name'].Value|[0],State.Name]" --output table
   
   # Terminate instances
   aws ec2 terminate-instances --region us-east-2 --instance-ids INSTANCE_ID
   ```

2. **Delete Key Pairs**
   ```bash
   # List key pairs
   aws ec2 describe-key-pairs --region us-east-2 --query "KeyPairs[].[KeyName,KeyPairId]" --output table
   
   # Delete key pair
   aws ec2 delete-key-pair --region us-east-2 --key-name easytrade-key
   ```

3. **Remove Local PEM Files**
   ```bash
   # Remove from current directory
   rm -f /home/ubuntu/mcpprojects/easytrade-demo/easytrade-key.pem
   rm -f /home/ubuntu/mcpprojects/easytrade-demo/*.pem
   ```

### Cleanup Verification
- Verify no running instances: `aws ec2 describe-instances --region us-east-2 --filters "Name=instance-state-name,Values=running"`
- Verify no easyTrade key pairs: `aws ec2 describe-key-pairs --region us-east-2`
- Verify local directory is clean of PEM files: `ls -la *.pem 2>/dev/null || echo "Clean"`

## Key Learnings from Deployment

### Deployment Performance
- **Actual deployment time**: 3 minutes (vs estimated 10-15 minutes)
- **User data script efficiency**: Highly optimized for parallel container startup
- **Container orchestration**: All 19 services start effectively in parallel
- **Resource utilization**: t3.large handles 19 services well

### OneAgent Integration
- **Post-deployment installation**: Successfully installed OneAgent AFTER containers were running
- **Auto-discovery**: OneAgent automatically detected and monitored all 19 microservices
- **Best practice confirmed**: Install OneAgent BEFORE containers for immediate monitoring
- **Monitoring coverage**: Full distributed tracing across all services

### Autostart Configuration
- **Service verification**: easytrade-autostart.service properly configured and enabled
- **Boot sequence**: Correctly depends on docker.service
- **User permissions**: Runs as ec2-user with docker group membership
- **Reliability**: Type=oneshot with RemainAfterExit=yes works perfectly for docker-compose

### Infrastructure Management
- **Stop vs Terminate**: Stop preserves all configuration, terminate removes everything
- **Public IP behavior**: Changes after stop/start cycle
- **Cost optimization**: Stopping saves compute costs while preserving setup
- **Quick restart**: 5-10 minutes to full operation from stopped state

### Security and Documentation
- **GitHub integration**: Successfully created public repository with protected secrets
- **File protection**: .gitignore effectively prevents sensitive file commits
- **Documentation completeness**: All deployment knowledge captured in markdown files

## Critical Mistakes to Avoid
- **Never commit secrets**: Always create .gitignore before first commit to protect sensitive files
- **Don't assume existing infrastructure**: Always check AWS resources first
- **Don't use hardcoded resource IDs**: Security groups, subnets vary by account/region
- **Don't skip Docker group membership**: User must be in docker group to run containers
- **Don't forget logout/login**: Required after adding user to docker group
- **Don't use docker-compose v1**: Must use Docker Compose Plugin (docker compose)
- **Always verify ports**: Use netstat to confirm services are listening on expected ports
- **Always terminate instances first** to avoid charges
- **Remove PEM files immediately** after deleting key pairs to prevent confusion
- **Allow stabilization time**: easyTrade takes several minutes to fully start all 19 services
