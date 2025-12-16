# easyTrade Kubernetes (k3s) Deployment Agent Context

## PROVEN SUCCESS FORMULA ✅
**m5.xlarge + Ubuntu 22.04 + 20GB disk + release manifests + NodePort security = PERFECT deployment**

## Critical Infrastructure Requirements
- **Instance Type**: m5.xlarge (4 vCPU, 16GB RAM) - ESSENTIAL for 19 microservices
- **OS**: Ubuntu 22.04 (ami-0ea3c35c5c3284d82)
- **Disk**: 20GB minimum (`--block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":20}}]'`)
- **Security Group**: Ports 22 (SSH) + NodePort (30000-32767 range)
- **User Data**: `#!/bin/bash\napt update -y\napt install -y git` (base64 encoded)

## EXACT DEPLOYMENT SEQUENCE (2-3 minutes total)

### 1. AWS Infrastructure
```bash
# Create key pair
aws ec2 create-key-pair --region us-east-2 --key-name easytrade-k3s-key --query 'KeyMaterial' --output text > easytrade-k3s-key.pem
chmod 400 easytrade-k3s-key.pem

# Launch instance (use existing security group sg-0401b2d1841473361)
aws ec2 run-instances --region us-east-2 --image-id ami-0ea3c35c5c3284d82 --instance-type m5.xlarge --key-name easytrade-k3s-key --security-group-ids sg-0401b2d1841473361 --count 1 --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":20}}]' --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=easyTrade-k3s}]' --user-data 'IyEvYmluL2Jhc2gKYXB0IHVwZGF0ZSAteQphcHQgaW5zdGFsbCAteSBnaXQ='
```

### 2. k3s Installation
```bash
ssh -i easytrade-k3s-key.pem ubuntu@PUBLIC_IP 'curl -sfL https://get.k3s.io | sh -'
```

### 3. Dynatrace Operator (CRITICAL: Create namespace first)
```bash
ssh -i easytrade-k3s-key.pem ubuntu@PUBLIC_IP 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo chmod 644 /etc/rancher/k3s/k3s.yaml && kubectl create namespace dynatrace && kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/latest/download/kubernetes.yaml'
```

### 4. easyTrade Deployment
```bash
ssh -i easytrade-k3s-key.pem ubuntu@PUBLIC_IP 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && kubectl create namespace easytrade && git clone https://github.com/Dynatrace/easytrade.git && cd easytrade && kubectl -n easytrade apply -f ./kubernetes-manifests/release'
```

### 5. Security Group Update
```bash
# Get NodePort from LoadBalancer service
kubectl -n easytrade get services frontendreverseproxy-easytrade
# Open the NodePort (e.g., 31055)
aws ec2 authorize-security-group-ingress --region us-east-2 --group-id sg-0401b2d1841473361 --protocol tcp --port NODEPORT --cidr 0.0.0.0/0
```

## Application Details
- **Repository**: https://github.com/Dynatrace/easytrade
- **Services**: 19 microservices (React frontend, SQL Server, RabbitMQ, etc.)
- **Access**: `http://PUBLIC_IP:NODEPORT`
- **Users**: `demouser/demopass`, `james_norton/pass_james_123`
- **Feature Flags**: `http://PUBLIC_IP:NODEPORT/feature-flag-service/v1/flags`

## Problem Patterns (5 available)
- `db_not_responding` - Database connectivity issues
- `factory_crisis` - Credit card production failure  
- `high_cpu_usage` - CPU throttling simulation
- `credit_card_meltdown` - Frontend error simulation
- `ergo_aggregator_slowdown` - Service delay patterns

## Critical Success Factors
1. **ALWAYS use release manifests** (`./kubernetes-manifests/release`) - NOT base
2. **Create namespaces BEFORE operator installation** (dynatrace, easytrade)
3. **m5.xlarge is non-negotiable** - t3.large causes service failures
4. **Open NodePort in security group** - application won't be accessible otherwise
5. **20GB disk prevents DiskPressure** - default 8GB causes pod evictions

## Verification Commands
```bash
# Check all pods running
kubectl -n easytrade get pods

# Test application
curl -I http://PUBLIC_IP:NODEPORT

# Check feature flags API
curl http://PUBLIC_IP:NODEPORT/feature-flag-service/v1/flags
```

## Status Management
- **ALWAYS update AmazonQ.md** after infrastructure changes
- **Check AmazonQ.md first** before creating new infrastructure
- **Document instance ID, IP, and NodePort** for future reference

## Cleanup Options
- **Stop instance**: Preserves config, changes IP, 2-3 minute restart
- **Terminate**: Complete removal, requires full redeployment

## Common Issues & Solutions
- **t3.large failures**: rabbitmq, manager, third-party-service fail due to insufficient RAM
- **Base manifests**: Development-only, use release manifests for proper registry paths
- **Missing NodePort**: Application loads but isn't accessible without security group rule
- **DiskPressure**: Default 8GB disk causes pod evictions, 20GB prevents this
- **Namespace order**: Create dynatrace namespace before operator installation
