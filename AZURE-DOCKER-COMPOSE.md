# easyTrade on Azure: Docker Compose Single-Host Deployment

Deploy all 19 easyTrade microservices on a single Azure VM using Docker Compose — no Kubernetes required.

**Source**: [github.com/Dynatrace/easytrade](https://github.com/Dynatrace/easytrade)

---

## Requirements

- Azure account with permission to create VMs and Network Security Groups
- Docker v20.10.13+ with Docker Compose Plugin (covered below)
- Recommended VM: **Standard_D4s_v3** (4 vCPU, 16GB RAM) — smaller sizes may cause service failures

> ⚠️ Docker Compose V1 (`docker-compose` binary) will **not** work. You need the Compose Plugin (`docker compose`).

---

## Step 1: Create the Azure VM

### Via Azure Portal

1. Go to **Virtual Machines → Create**
2. Configure:
   - **Image**: Ubuntu Server 22.04 LTS
   - **Size**: Standard_D4s_v3 (4 vCPU, 16GB RAM)
   - **Authentication**: SSH public key (recommended)
   - **OS disk**: 30GB minimum
3. Under **Networking**, note the Network Security Group (NSG) — you'll update it in Step 3

### Via Azure CLI

```bash
# Create resource group
az group create --name easytrade-rg --location eastus

# Create VM
az vm create \
  --resource-group easytrade-rg \
  --name easytrade-vm \
  --image Ubuntu2204 \
  --size Standard_D4s_v3 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --os-disk-size-gb 30

# Get the public IP
az vm show -d --resource-group easytrade-rg --name easytrade-vm --query publicIps -o tsv
```

---

## Step 2: Open Port 80 in the NSG

easyTrade's reverse proxy listens on **port 80**.

### Via Azure Portal

1. Go to your VM → **Networking** → **Add inbound port rule**
2. Set: Destination port `80`, Protocol `TCP`, Action `Allow`

### Via Azure CLI

```bash
az network nsg rule create \
  --resource-group easytrade-rg \
  --nsg-name easytrade-vmNSG \
  --name allow-http \
  --protocol tcp \
  --priority 1010 \
  --destination-port-range 80 \
  --access Allow
```

---

## Step 3: Connect to the VM

```bash
ssh azureuser@<YOUR_VM_PUBLIC_IP>
```

---

## Step 4: Install Docker and Docker Compose Plugin

```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow current user to run docker without sudo
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
```

---

## Step 5: Deploy easyTrade

```bash
# Clone the official repo
git clone https://github.com/Dynatrace/easytrade.git
cd easytrade

# Start all 19 services in the background
docker compose up -d
```

This pulls images from the Dynatrace public registry and starts all services. Allow **3-5 minutes** for full stabilization.

---

## Step 6: Verify Deployment

```bash
# Check all containers are running
docker compose ps

# Watch logs (optional)
docker compose logs -f frontendreverseproxy
```

All services should show status `Up`. The app is ready when `frontendreverseproxy` is healthy.

---

## Access the Application

Open your browser:

```
http://<YOUR_VM_PUBLIC_IP>
```

### Default Users

| Username | Password | Notes |
|----------|----------|-------|
| demouser | demopass | Basic demo user |
| specialuser | specialpass | Special demo user |
| james_norton | pass_james_123 | Has pre-populated trading data |

> After creating a new user there is no confirmation — just go back to the login page and sign in.

---

## Problem Patterns

easyTrade includes 4 built-in problem patterns for demonstrations (all disabled by default).

### Check current state

```bash
curl http://localhost/feature-flag-service/v1/flags
```

### Enable a pattern

```bash
curl -X PUT "http://localhost/feature-flag-service/v1/flags/DbNotResponding/" \
  -H "Content-Type: application/json" \
  -d '{"enabled": true}'
```

### Available patterns

| Pattern | Effect |
|---------|--------|
| `DbNotResponding` | Blocks new trades — database throws errors |
| `ErgoAggregatorSlowdown` | Aggregators slow down and drop traffic |
| `FactoryCrisis` | Credit card production stops |
| `HighCpuUsage` | Broker service CPU spike |

---

## Useful Commands

```bash
# Stop all services (preserves data)
docker compose stop

# Start again
docker compose start

# Full teardown (removes containers and volumes)
docker compose down -v

# View logs for a specific service
docker compose logs -f broker-service

# Restart a single service
docker compose restart frontend

# Check resource usage
docker stats
```

---

## Cost Management

```bash
# Stop the VM when not in use (preserves disk, stops compute charges)
az vm deallocate --resource-group easytrade-rg --name easytrade-vm

# Start again (public IP may change)
az vm start --resource-group easytrade-rg --name easytrade-vm

# Get new public IP after restart
az vm show -d --resource-group easytrade-rg --name easytrade-vm --query publicIps -o tsv
```

---

## Full Cleanup

```bash
# Delete everything (permanent)
az group delete --name easytrade-rg --yes --no-wait
```

---

## Troubleshooting

**Services not starting / crashing**
- Check VM has enough RAM: `free -h` — need at least 12GB available
- Check disk space: `df -h` — need at least 10GB free
- View logs: `docker compose logs <service-name>`

**App not accessible on port 80**
- Confirm NSG rule allows inbound TCP port 80
- Confirm `frontendreverseproxy` container is running: `docker compose ps`

**Docker Compose command not found**
- Ensure you installed the **plugin** version: `sudo apt install docker-compose-plugin`
- Use `docker compose` (with space), not `docker-compose`

**Slow startup / missing data**
- Normal — allow 3-5 minutes after `docker compose up -d` for all services to stabilize

---

**Official repo**: https://github.com/Dynatrace/easytrade
