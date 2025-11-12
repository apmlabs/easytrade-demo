# easyTrade Kubernetes (k3s) Deployment Agent Context

You are an agent that helps deploy and troubleshoot easyTrade demo application on AWS EC2 using Kubernetes (k3s).

Repository URL: https://github.com/Dynatrace/easytrade

## Deployment Information
- easyTrade is a microservices-based stock trading demo application developed by Dynatrace
- Consists of 19 interconnected services showcasing distributed tracing and monitoring
- **PRIMARY DEPLOYMENT**: Kubernetes (k3s) on AWS EC2 instances
- **ALTERNATIVE**: Docker Compose (legacy approach)
- Official repository: https://github.com/Dynatrace/easytrade
- Modern cloud-native application with built-in problem patterns for demonstration
- **KUBERNETES READY**: Official Kubernetes manifests available in repository

## Application Architecture
easyTrade consists of 19 microservices:
- **Frontend**: React-based trading interface
- **Backend Services**: Account, Broker, Pricing, Login, Manager, Engine services
- **Database**: SQL Server with pre-populated trading data
- **Message Queue**: RabbitMQ for async communication
- **Load Generator**: Built-in synthetic traffic generation
- **Problem Patterns**: 4 configurable problem scenarios for demonstration

## EC2 Instance Requirements
- **CRITICAL SUCCESS**: m5.xlarge (4 vCPU, 16GB RAM) - PERFECT for all 19 microservices in k3s
- **FAILED**: t3.large (8GB RAM) is INSUFFICIENT - causes 3 critical services to fail (rabbitmq, manager, third-party-service)
- **Memory Usage**: k3s deployment uses ~97% of 8GB RAM, but only ~50% of 16GB RAM
- **Cost-Effective**: m5.xlarge provides sustained performance without CPU credits limitation
- **Storage**: 50GB recommended for container images and logs
- **OS**: Ubuntu 22.04 (works perfectly with k3s)
- **Ports**: 22 (SSH), 80, 6443 (k3s API server), PLUS NodePort range (30000-32767)

## Kubernetes (k3s) Deployment Strategy
- **k3s**: Lightweight Kubernetes distribution perfect for single-node deployments
- **Official Manifests**: easyTrade repository includes complete Kubernetes manifests
- **Kustomize**: Uses Kustomize for configuration management
- **LoadBalancer**: Uses k3s built-in LoadBalancer (Traefik) for external access
- **Resource Management**: Proper resource requests/limits defined for all services
- **Service Mesh**: Native Kubernetes service discovery and networking

## Installation Process (CRITICAL: Dynatrace Operator)
1. **EC2 Setup**: Launch instance with proper security group (ports 22, 80, 6443)
2. **k3s Installation**: Install k3s single-node cluster
3. **Git Installation**: Install git (required for Amazon Linux 2)
4. **Dynatrace Operator**: Install Dynatrace operator for Kubernetes monitoring
5. **Repository Clone**: Clone easyTrade repository
6. **Kubernetes Deployment**: Apply manifests using kubectl/kustomize
7. **Verification**: Check pod status and application accessibility

**DEPLOYMENT TIMING**: k3s deployment takes ~5-7 minutes (slightly longer than Docker Compose)
- k3s cluster initialization: ~2 minutes
- Container pulls and pod startup: ~3-5 minutes
- All 19 services start with proper orchestration
- Built-in health checks and readiness probes

**DYNATRACE OPERATOR INSTALLATION**: Install after k3s cluster is ready
- Dynatrace operator auto-discovers and monitors all 19 microservices
- Installing after pods provides full monitoring coverage
- k3s provides better observability integration than Docker Compose

## k3s Requirements
- **k3s**: Lightweight Kubernetes distribution (single binary)
- **kubectl**: Included with k3s installation
- **Kustomize**: Built into kubectl for manifest management
- **Installation**:
```bash
# Amazon Linux 2 / Ubuntu
curl -sfL https://get.k3s.io | sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## Kubernetes Manifest Structure
- **Base Manifests**: `/kubernetes-manifests/base/` - 21 YAML files
- **Kustomization**: Uses Kustomize for configuration management
- **Services**: All 19 microservices with proper resource limits
- **LoadBalancer**: frontendreverseproxy exposed via k3s LoadBalancer
- **ConfigMaps**: Connection strings and environment variables
- **Problem Operator**: Kubernetes-native problem pattern management

## Dynatrace Operator Installation

### Prerequisites
- k3s cluster running and accessible
- kubectl configured with KUBECONFIG=/etc/rancher/k3s/k3s.yaml

### Installation Steps
```bash
# 1. Create Dynatrace namespace
kubectl create namespace dynatrace

# 2. Install Dynatrace operator
kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes.yaml

# 3. Apply secrets (API tokens)
kubectl apply -f secrets-easytrade.yaml

# 4. Apply DynaKube configuration
kubectl apply -f dynakube-easytrade.yaml

# 5. Verify installation
kubectl get pods -n dynatrace
kubectl get dynakube -n dynatrace
```

### Configuration Files
- **secrets-easytrade.yaml**: Contains API token and data ingest token
- **dynakube-easytrade.yaml**: DynaKube configuration for easyTrade monitoring
- **Tenant URL**: https://cyu0810h.sprint.dynatracelabs.com
- **Same tokens as astroshop-demo**: Reuses existing API keys for consistency

### Monitoring Coverage
- **All 19 microservices**: Automatic discovery and monitoring
- **Kubernetes metadata**: Pod, service, and deployment enrichment
- **Distributed tracing**: Full trace coverage across services
- **Log monitoring**: Container log collection and analysis
- **ActiveGate**: Kubernetes monitoring and routing capabilities

## Security Group Configuration
- Port 22: SSH access (restrict to your IP)
- Port 80: Main application (0.0.0.0/0 or restricted)
- Port 6443: k3s API server (optional, for kubectl access)

## Application Access
- **Main Application**: `http://YOUR_EC2_PUBLIC_IP:80`
- **Default Users**:
  - `demouser/demopass`
  - `specialuser/specialpass`
  - `james_norton/pass_james_123` (has pre-populated data)

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
curl -X PUT "http://18.224.57.90/feature-flag-service/v1/flags/{PATTERN_ID}/" \
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
# All pods
kubectl get pods -o wide

# Services and LoadBalancer
kubectl get services

# Feature flags
curl http://EXTERNAL_IP/feature-flag-service/v1/flags
```

### Infrastructure Control:
```bash
# Stop instance (preserve config)
aws ec2 stop-instances --region us-east-2 --instance-ids INSTANCE_ID

# Start instance (get new IP)
aws ec2 start-instances --region us-east-2 --instance-ids INSTANCE_ID
```

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

## GitHub Repository Management
- **GitHub Setup**: Follow GITHUB.md in this folder for repository setup instructions
- **When asked about GitHub repositories**: Reference the GITHUB.md file in this project folder
- **Critical**: Always check .gitignore before committing - AmazonQ.md should NEVER be committed

## Rules
- Always update AGENTS.md when discovering new deployment insights
- **Current status is in AmazonQ.md context** - check existing deployment before creating new infrastructure
- Use AWS CLI to verify resources before creating new ones
- Document any deployment issues and their solutions
- Test application accessibility after deployment
- **Default Infrastructure Behavior**: Check AmazonQ.md first - only create new infrastructure if none exists
- **Default Region**: Use us-east-2 unless otherwise specified
- **Status Reporting**: Current deployment status is always available in AmazonQ.md context
- **CRITICAL: ALWAYS UPDATE STATUS FILES** - After ANY infrastructure change (start/stop/terminate/create), immediately update the easytrade-demo status documentation (AmazonQ.md) to reflect current state. Failure to update status files causes context loss and repeated mistakes across chat sessions.

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
- k3s cluster and all pods will restart automatically

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

## Key Learnings from k3s Deployment

### Deployment Performance
- **k3s cluster startup**: ~2 minutes for single-node cluster initialization
- **Pod deployment time**: 5-7 minutes for all 19 microservices
- **Container orchestration**: Kubernetes handles dependencies and startup order
- **Resource utilization**: m5.xlarge handles all 19 services perfectly with room to spare
- **Restart performance**: k3s cluster restart takes ~2-3 minutes, full pod stabilization ~5-7 minutes

### Service Architecture
- **Total services**: 19 microservices with Kubernetes-native networking
- **Load generator**: Built-in with 5 concurrent workers generating realistic traffic patterns
- **Problem patterns**: 5 available patterns managed via Kubernetes problem operator
- **Feature flag service**: Accessible via LoadBalancer service on NodePort
- **Service discovery**: Native Kubernetes DNS for inter-service communication

### Critical Success Factors
- **m5.xlarge is ESSENTIAL**: 16GB RAM required for all 19 services
- **Ubuntu 22.04**: Works better than Amazon Linux 2 for k3s
- **Image registry configuration**: Must be done from start with correct Dynatrace registry
- **NodePort security groups**: Always open the assigned NodePort for public access
- **k3s LoadBalancer**: Works via NodePort, external IP stays pending (normal behavior)

### OneAgent Integration
- **Pre-deployment installation**: Install OneAgent BEFORE applying Kubernetes manifests
- **Auto-discovery**: OneAgent automatically detects and monitors all 19 microservices
- **Container monitoring**: Full visibility into Kubernetes pods and containers
- **Distributed tracing**: Complete trace coverage across all services
- **Best practice**: OneAgent installation before pod creation ensures immediate monitoring

### Kubernetes Advantages over Docker Compose
- **Resource management**: Proper CPU/memory requests and limits
- **Health checks**: Built-in readiness and liveness probes
- **Service discovery**: Native Kubernetes DNS resolution
- **Load balancing**: Automatic load balancing via Services
- **Scaling**: Easy horizontal pod autoscaling capabilities
- **Observability**: Better integration with monitoring tools

### k3s Specific Benefits
- **Lightweight**: Single binary installation, minimal resource overhead
- **Built-in LoadBalancer**: Traefik ingress controller included
- **Storage**: Local path provisioner for persistent volumes
- **Networking**: Flannel CNI for pod networking
- **API Server**: Full Kubernetes API compatibility

## k3s Deployment Process

### 1. Install k3s
```bash
# Install k3s single-node cluster
curl -sfL https://get.k3s.io | sh -

# Configure kubectl access
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Verify cluster is ready
kubectl get nodes
```

### 2. Clone easyTrade Repository
```bash
git clone https://github.com/Dynatrace/easytrade.git
cd easytrade
```

### 3. Deploy with Kustomize
```bash
# Apply all manifests using kustomize
kubectl apply -k kubernetes-manifests/base/

# Wait for all pods to be ready
kubectl wait --for=condition=ready pod --all --timeout=600s

# Check deployment status
kubectl get pods -o wide
kubectl get services
```

### 4. Access Application
```bash
# Get LoadBalancer external IP
kubectl get service frontendreverseproxy-easytrade

# Application will be available at:
# http://EXTERNAL_IP:80
```

### 5. Verify Problem Patterns
```bash
# Check feature flag service
curl http://EXTERNAL_IP/feature-flag-service/v1/flags

# Enable a problem pattern
curl -X PUT "http://EXTERNAL_IP/feature-flag-service/v1/flags/db_not_responding/" \
-H "accept: application/json" \
-d '{"enabled": true}'
```

## k3s Troubleshooting Commands

### Pod Management
```bash
# Check pod status
kubectl get pods -o wide

# View pod logs
kubectl logs -f deployment/frontend

# Describe problematic pod
kubectl describe pod POD_NAME

# Restart deployment
kubectl rollout restart deployment/frontend
```

### Service Debugging
```bash
# Check services and endpoints
kubectl get services
kubectl get endpoints

# Test internal connectivity
kubectl exec -it deployment/frontend -- curl http://broker-service:8080/health

# Port forward for debugging
kubectl port-forward service/frontend 3000:3000
```

### Resource Monitoring
```bash
# Check resource usage
kubectl top nodes
kubectl top pods

# View events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check cluster info
kubectl cluster-info
```

## k3s Manifest Structure Analysis

The easyTrade Kubernetes manifests include:

### Core Services (19 total)
1. **db** - SQL Server database
2. **rabbitmq** - Message queue
3. **contentcreator** - Database initialization
4. **manager** - Trade management service
5. **pricing-service** - Stock pricing
6. **broker-service** - Trading operations
7. **calculationservice** - Trade calculations
8. **frontend** - React UI
9. **loginservice** - Authentication
10. **frontendreverseproxy** - Load balancer/proxy
11. **loadgen** - Traffic generator
12. **offerservice** - Stock offers
13. **feature-flag-service** - Problem pattern control
14. **accountservice** - User accounts
15. **engine** - Trading engine
16. **credit-card-order-service** - Payment processing
17. **third-party-service** - External integrations
18. **aggregator-service** - Metrics aggregation
19. **problem-operator** - Problem pattern operator

### Resource Specifications
- **CPU requests**: 10m-50m per service
- **Memory requests**: 75Mi-200Mi per service
- **Memory limits**: 75Mi-200Mi per service
- **Total cluster requirements**: ~2GB RAM, 1 CPU core minimum

### Service Types
- **ClusterIP**: Internal services (most services)
- **LoadBalancer**: frontendreverseproxy-easytrade (external access)
- **ConfigMap**: connection-strings (database connections)

### Service Architecture
- **Total services**: 18 microservices (not 19 as initially documented)
- **Load generator**: Built-in with 5 concurrent workers generating realistic traffic patterns
- **Problem patterns**: 5 available patterns (including credit_card_meltdown not in original docs)
- **Feature flag service**: Runs on internal port 8080, accessible via `/feature-flag-service/v1/flags`

### OneAgent Integration
- **Post-deployment installation**: Successfully installed OneAgent AFTER containers were running
- **Auto-discovery**: OneAgent automatically detected and monitored all 18 microservices
- **Best practice confirmed**: Install OneAgent BEFORE containers for immediate monitoring
- **Monitoring coverage**: Full distributed tracing across all services
- **Container monitoring**: 17+ oneagenthelper processes actively monitoring containers

### Problem Pattern Management
- **API endpoint**: `http://IP/feature-flag-service/v1/flags` (requires service prefix)
- **Pattern IDs**: Use underscores not camelCase (`db_not_responding` not `DbNotResponding`)
- **Available patterns**: db_not_responding, ergo_aggregator_slowdown, factory_crisis, high_cpu_usage, credit_card_meltdown
- **Frontend control**: Enabled via `frontend_feature_flag_management` flag
- **Service stabilization**: Wait 3-5 minutes after restart before API calls work properly

### Load Generation
- **Built-in traffic**: 5 workers with realistic user scenarios
- **Traffic patterns**: order_credit_card, deposit_and_buy_success, deposit_and_long_buy_error, etc.
- **Synthetic users**: Generates realistic profiles with IP addresses
- **Browser simulation**: Uses headless browsers for authentic interactions

### Autostart Configuration
- **Service verification**: easytrade-autostart.service properly configured and enabled
- **Boot sequence**: Correctly depends on docker.service
- **User permissions**: Runs as ec2-user with docker group membership
- **Reliability**: Type=oneshot with RemainAfterExit=yes works perfectly for docker-compose

### Infrastructure Management
- **Stop vs Terminate**: Stop preserves all configuration, terminate removes everything
- **Public IP behavior**: Changes after stop/start cycle (AWS assigns new IP each time)
- **Cost optimization**: Stopping saves compute costs while preserving setup
- **Quick restart**: 3-5 minutes to full operation from stopped state
- **Service count**: Always verify actual running containers vs documentation

### Troubleshooting
- **Service routing**: All services accessible via reverse proxy with service prefix
- **API timing**: Feature flag service needs stabilization time after container start
- **Container logs**: Use `docker compose logs service-name` for debugging
- **Network connectivity**: Test internal service connectivity before external API calls

### Security and Documentation
- **GitHub integration**: Successfully created public repository with protected secrets
- **File protection**: .gitignore effectively prevents sensitive file commits
- **Documentation completeness**: All deployment knowledge captured in markdown files

## Critical Mistakes to Avoid
- **Never commit secrets**: Always create .gitignore before first commit to protect sensitive files
- **AmazonQ.md is ALWAYS in .gitignore**: Contains sensitive deployment info and should never be tracked
- **If AmazonQ.md was previously tracked**: Use `git rm --cached AmazonQ.md` to remove from tracking
- **Don't assume existing infrastructure**: Always check AWS resources first
- **Don't use hardcoded resource IDs**: Security groups, subnets vary by account/region
- **Don't skip k3s cluster verification**: Always check `kubectl get nodes` before deploying
- **Don't forget KUBECONFIG**: Export KUBECONFIG=/etc/rancher/k3s/k3s.yaml for kubectl access
- **Don't use docker-compose commands**: This is k3s deployment, use kubectl commands
- **Always verify LoadBalancer**: Use `kubectl get services` to confirm external IP assignment
- **CRITICAL: ALWAYS UPDATE STATUS FILES** - After ANY infrastructure change (start/stop/terminate/create), immediately update the easytrade-demo status documentation (AmazonQ.md) to reflect current state. Failure to update status files causes context loss and repeated mistakes across chat sessions.
- **MEMORY CRITICAL**: t3.large insufficient for 19 services - causes rabbitmq, manager, third-party-service to fail
- **NodePort Security Groups**: Always open the NodePort in security group for public access
- **Resource Constraints Break Functionality**: Missing critical services (rabbitmq, manager) cause application to load but not work properly
- **SUCCESS FORMULA**: m5.xlarge + Ubuntu 22.04 + proper image registry + NodePort security group = PERFECT deployment
