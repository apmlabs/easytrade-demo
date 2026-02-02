# Amazon Q Context - easyTrade Kubernetes (k3s) Demo Status

## Current Deployment Status: STOPPED 🛑

**Last Updated**: December 17, 2025 10:08 UTC

## Stopped Infrastructure
- **EC2 Instance**: i-089164961f177931b (m5.xlarge, us-east-2) - STOPPED
- **Key Pair**: easytrade-k3s-key (preserved)
- **Security Group**: sg-0401b2d1841473361 (preserved)

## Application Status
🛑 **easyTrade Demo STOPPED** (all configuration preserved)
- Instance stopped to save costs
- All 19 services configuration intact
- Ready for quick restart (2-3 minutes for full startup)
- k3s cluster will restore all containers on restart

## Key Context for Conversations
- **DO NOT create new infrastructure** - existing instance just needs restart
- **All configuration preserved** - no redeployment needed
- **Quick restart available** - just start the existing instance
- **Public IP will change** after restart (get new IP from AWS)

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids i-089164961f177931b

# Get new public IP after restart
aws ec2 describe-instances --region us-east-2 --instance-ids i-089164961f177931b --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```

## Application Services Architecture
1. **Frontend Layer**: React frontend + reverse proxy
2. **API Layer**: Account, Broker, Pricing, Login services
3. **Business Logic**: Manager, Engine, Offer services
4. **Integration**: Credit Card, Third Party services
5. **Infrastructure**: Database, RabbitMQ, Feature Flags
6. **Utilities**: Load Generator, Calculation, Content Creator
7. **Monitoring**: Aggregator services for metrics

## Problem Patterns Available
1. **db_not_responding**: Database connectivity issues
2. **ergo_aggregator_slowdown**: Service performance degradation
3. **factory_crisis**: Credit card processing failures
4. **high_cpu_usage**: Resource constraint simulation
5. **credit_card_meltdown**: Frontend error simulation

## Default Application Users
- `demouser/demopass`
- `specialuser/specialpass`
- `james_norton/pass_james_123` (has pre-populated data)

---

## Status Templates for Different States

### When Instance is ACTIVE (use this template):
```
## Current Deployment Status: ACTIVE ✅

**Last Updated**: [TIMESTAMP]

## Active Infrastructure
- **EC2 Instance**: [INSTANCE_ID] (m5.xlarge, us-east-2) - RUNNING
- **Public IP**: [PUBLIC_IP]
- **Key Pair**: easytrade-k3s-key
- **Security Group**: [SG_ID] (ports 22, NODEPORT)

## Application Status
✅ **easyTrade Demo FULLY DEPLOYED and RUNNING**
- All 19 microservices operational
- Dynatrace operator installed and running
- k3s cluster healthy with proper resource allocation
- Application accessible at http://[PUBLIC_IP]:NODEPORT

## Quick Access
- **Main Application**: http://[PUBLIC_IP]:NODEPORT
- **Default Users**: demouser/demopass, specialuser/specialpass, james_norton/pass_james_123

## Key Context for Conversations
- **DO NOT create new infrastructure** - demo is already running
- **Current deployment is production-ready** with monitoring
- **Instance will auto-restart** all 19 services after reboot
- **Dynatrace operator properly installed** before containers for full monitoring

## Available Actions
- Check application status
- Access demo URLs
- Test problem patterns
- **Shutdown instance** (preserves all config for later restart)
- **Terminate completely** (permanent cleanup)
```

### When Instance is STOPPED (use this template):
```
## Current Deployment Status: STOPPED 🛑

**Last Updated**: [TIMESTAMP]

## Stopped Infrastructure
- **EC2 Instance**: [INSTANCE_ID] (m5.xlarge, us-east-2) - STOPPED
- **Key Pair**: easytrade-k3s-key (preserved)
- **Security Group**: [SG_ID] (preserved)

## Application Status
🛑 **easyTrade Demo STOPPED** (all configuration preserved)
- Instance stopped to save costs
- All 19 services configuration intact
- Ready for quick restart (2-3 minutes for full startup)
- k3s cluster will restore all containers on restart

## Key Context for Conversations
- **DO NOT create new infrastructure** - existing instance just needs restart
- **All configuration preserved** - no redeployment needed
- **Quick restart available** - just start the existing instance
- **Public IP will change** after restart (get new IP from AWS)

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids [INSTANCE_ID]

# Get new public IP after restart
aws ec2 describe-instances --region us-east-2 --instance-ids [INSTANCE_ID] --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```
```

### When Infrastructure is TERMINATED (use this template):
```
## Current Deployment Status: NO DEPLOYMENT 🚫

**Last Updated**: [TIMESTAMP]

## Infrastructure Status
- **No active infrastructure** - all resources terminated
- **Clean slate** - ready for new deployment

## Key Context for Conversations
- **Infrastructure needed** - no existing deployment
- **Fresh deployment required** - follow full setup process
- **No preserved configuration** - start from scratch
- **19 services need full deployment** - allow 5-7 minutes

## Available Actions
- Deploy new easyTrade infrastructure
- Follow complete setup guide
- Create new EC2 instance with proper configuration
```

## Notes
- easyTrade requires m5.xlarge for 19 microservices (t3.large fails)
- Startup sequence is critical - database and message queue must be ready first
- Problem patterns are sophisticated and business-focused
- Application includes built-in load generation for realistic testing
