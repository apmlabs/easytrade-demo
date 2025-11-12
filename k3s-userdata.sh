#!/bin/bash

# Update system
yum update -y
yum install git -y

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Configure kubectl access
chmod 644 /etc/rancher/k3s/k3s.yaml
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /home/ec2-user/.bashrc

# Wait for k3s to be ready
sleep 30
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Clone easyTrade repository
cd /home/ec2-user
git clone https://github.com/Dynatrace/easytrade.git
chown -R ec2-user:ec2-user easytrade

# Deploy easyTrade using Kubernetes manifests
cd easytrade
kubectl apply -k kubernetes-manifests/base/

# Create completion marker
echo "k3s and easyTrade deployment completed at $(date)" > /home/ec2-user/deployment-complete.log
chown ec2-user:ec2-user /home/ec2-user/deployment-complete.log
