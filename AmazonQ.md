# Amazon Q Context - easyTrade Demo Status

> ⚠️ **Infrastructure details** (instance ID, security group, public IP) are stored in `infra-details.md` (gitignored, local only).

## Current Deployment Status: STOPPED 🛑

**Last Updated**: December 4, 2025 12:57 UTC

## Stopped Infrastructure
- **EC2 Instance**: see `infra-details.md` (t3.large, us-east-2) - STOPPED
- **Key Pair**: easytrade-key (preserved)
- **Security Group**: see `infra-details.md` (preserved)

## Application Status
🛑 **easyTrade Demo STOPPED** (all configuration preserved)
- Instance stopped to save costs
- All 19 services configuration intact
- Ready for quick restart (3-5 minutes for full startup)
- Autostart service will restore all containers on restart

## Problem Patterns Available
- **5 patterns available**: db_not_responding, ergo_aggregator_slowdown, factory_crisis, high_cpu_usage, credit_card_meltdown
- **All currently disabled** - ready for demonstration
- **Frontend control enabled** via frontend_feature_flag_management flag

## Quick Access
- **Main Application**: see `infra-details.md` for current IP
- **Default Users**: demouser/demopass, specialuser/specialpass, james_norton/pass_james_123

## Key Context for Conversations
- **DO NOT create new infrastructure** - existing instance just needs restart
- **All configuration preserved** - no redeployment needed
- **Quick restart available** - just start the existing instance
- **Public IP will change** after restart (get new IP from AWS)
- **Instance/SG IDs**: stored in `infra-details.md` (local only, gitignored)

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

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
- **EC2 Instance**: see infra-details.md (us-east-2)
- **Public IP**: see infra-details.md
- **Key Pair**: easytrade-key
- **Security Group**: see infra-details.md

## Application Status
✅ **easyTrade Demo FULLY DEPLOYED and RUNNING**
- All 19 microservices operational
- Dynatrace OneAgent installed and monitoring
- Autostart service configured for persistence
- Application accessible at http://[PUBLIC_IP]:NodePort

## Quick Access
- **Main Application**: see infra-details.md for current IP and port
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
- **EC2 Instance**: see infra-details.md (us-east-2) - STOPPED
- **Key Pair**: easytrade-key (preserved)
- **Security Group**: see infra-details.md (preserved)

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
- **Instance/SG IDs**: stored in infra-details.md (local only)

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# See infra-details.md for INSTANCE_ID
aws ec2 start-instances --region us-east-2 --instance-ids [INSTANCE_ID]
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
