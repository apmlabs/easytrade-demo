# Amazon Q Context - easyTrade Demo Status

## Current Deployment Status: ACTIVE ✅

**Last Updated**: October 24, 2025 23:39 UTC

## Active Infrastructure
- **EC2 Instance**: i-0b9a5f06e7c7268dd (t3.large, us-east-2)
- **Public IP**: 3.140.198.157
- **Key Pair**: easytrade-key
- **Security Group**: sg-0decf9989aba71016 (ports 22, 80)

## Application Status
✅ **easyTrade Demo FULLY DEPLOYED and RUNNING**
- All 19 microservices operational
- Dynatrace OneAgent installed and monitoring
- Autostart service configured for persistence
- Application accessible at http://3.140.198.157:80

## Quick Access
- **Main Application**: http://3.140.198.157:80
- **Default Users**: demouser/demopass, specialuser/specialpass, james_norton/pass_james_123

## Key Context for Conversations
- **DO NOT create new infrastructure** - demo is already running
- **Current deployment is production-ready** with monitoring and autostart
- **Instance will auto-restart** all 19 services after reboot
- **OneAgent properly installed** before containers for full monitoring

## Available Actions
- Check application status
- Access demo URLs
- Test problem patterns
- **Shutdown instance** (preserves all config for later restart)
- **Terminate completely** (permanent cleanup)
- **DO NOT create new infrastructure** - existing instance just needs restart
- **All configuration preserved** - no redeployment needed
- **Quick restart available** - just start the existing instance
- **Public IP will change** after restart (get new IP from AWS)
- **Autostart verified working** - all services will auto-launch

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids i-0b9a5f06e7c7268dd

# Get new public IP after restart
aws ec2 describe-instances --region us-east-2 --instance-ids i-0b9a5f06e7c7268dd --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```

## Key Differences from easyTravel
- **Scale**: 19 services vs 6-8 services in easyTravel
- **Database**: SQL Server vs MongoDB in easyTravel
- **Message Queue**: RabbitMQ for async communication
- **Frontend**: React-based vs Java-based in easyTravel
- **Problem Patterns**: 4 specific patterns vs general patterns
- **Resource Requirements**: Higher memory and CPU needs (8GB RAM minimum)

## Application Services Architecture
1. **Frontend Layer**: React frontend + reverse proxy
2. **API Layer**: Account, Broker, Pricing, Login services
3. **Business Logic**: Manager, Engine, Offer services
4. **Integration**: Credit Card, Third Party services
5. **Infrastructure**: Database, RabbitMQ, Feature Flags
6. **Utilities**: Load Generator, Calculation, Content Creator
7. **Monitoring**: Aggregator services for metrics

## Problem Patterns Available
1. **DbNotResponding**: Database connectivity issues
2. **ErgoAggregatorSlowdown**: Service performance degradation
3. **FactoryCrisis**: Credit card processing failures
4. **HighCpuUsage**: Resource constraint simulation

## Docker Requirements
- **Docker Version**: Minimum v20.10.13 required
- **Docker Compose**: Must use Plugin version (NOT v1)
- **Memory**: 8GB RAM minimum for 19 services
- **Startup Time**: 5-10 minutes for full stabilization

## Default Application Users
- `demouser/demopass`
- `specialuser/specialpass`
- `james_norton/pass_james_123` (has pre-populated data)

## Learning Objectives
- [ ] Understand microservices communication patterns
- [ ] Learn distributed tracing across 19 services
- [ ] Practice container orchestration at scale
- [ ] Explore business event capture
- [ ] Study problem pattern simulation
- [ ] Gain experience with service mesh concepts

## Key Context for Conversations
- **NO ACTIVE DEPLOYMENT** - infrastructure needs to be created
- **Higher resource requirements** than easyTravel due to 19 services
- **Startup sequence critical** - database and message queue must be ready first
- **Problem patterns more sophisticated** and business-focused
- **Built-in load generation** for realistic testing scenarios

## Available Actions
- Create AWS infrastructure (EC2, security group, key pair)
- Deploy easyTrade application with 19 microservices
- Install Dynatrace OneAgent for monitoring
- Configure autostart service for persistence
- Test problem patterns and distributed tracing
- Set up business event capture

## Next Steps
1. Create deployment scripts adapted for easyTrade
2. Set up AWS infrastructure
3. Deploy and configure the application
4. Test problem patterns
5. Document lessons learned

---

## Status Templates for Different States

### When Instance is ACTIVE (use this template):
```
## Current Deployment Status: ACTIVE ✅

**Last Updated**: [TIMESTAMP]

## Active Infrastructure
- **EC2 Instance**: [INSTANCE_ID] (t3.large/xlarge, us-east-2)
- **Public IP**: [PUBLIC_IP]
- **Key Pair**: easytrade-key
- **Security Group**: [SG_ID] (ports 22, 80)

## Application Status
✅ **easyTrade Demo FULLY DEPLOYED and RUNNING**
- All 19 microservices operational
- Dynatrace OneAgent installed and monitoring
- Autostart service configured for persistence
- Application accessible at http://[PUBLIC_IP]:80

## Quick Access
- **Main Application**: http://[PUBLIC_IP]:80
- **Default Users**: demouser/demopass, specialuser/specialpass, james_norton/pass_james_123

## Key Context for Conversations
- **DO NOT create new infrastructure** - demo is already running
- **Current deployment is production-ready** with monitoring and autostart
- **Instance will auto-restart** all 19 services after reboot
- **OneAgent properly installed** before containers for full monitoring

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
- **EC2 Instance**: [INSTANCE_ID] (t3.large/xlarge, us-east-2) - STOPPED
- **Key Pair**: easytrade-key (preserved)
- **Security Group**: [SG_ID] (preserved)

## Application Status
🛑 **easyTrade Demo STOPPED** (all configuration preserved)
- Instance stopped to save costs
- All 19 services configuration intact
- Ready for quick restart (5-10 minutes for full startup)
- Autostart service will restore all containers on restart

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
- **19 services need full deployment** - allow 10-15 minutes

## Available Actions
- Deploy new easyTrade infrastructure
- Follow complete setup guide
- Create new EC2 instance with proper configuration
```

## Notes
- easyTrade requires more resources than easyTravel due to service count
- Startup sequence is critical - database and message queue must be ready first
- Problem patterns are more sophisticated and business-focused
- Application includes built-in load generation for realistic testing
