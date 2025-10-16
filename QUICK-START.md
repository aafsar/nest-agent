# Quick Start Guide

Get your 10-agent startup evaluation team deployed and running in ~30 minutes.

## Prerequisites Checklist

- [X] AWS CLI installed and configured
- [X] IAM user with EC2FullAccess
- [X] NEST repository cloned locally
- [ ] Anthropic API key ready
- [ ] ~30 minutes of time

## Step-by-Step Deployment

### Step 1: Add Your API Key

Edit `shared-config.env` and add your Anthropic API key:

```bash
nano shared-config.env
```

Change this line:
```bash
ANTHROPIC_API_KEY=""
```

To:
```bash
ANTHROPIC_API_KEY="sk-ant-api03-your-actual-key-here"
```

Save and exit (Ctrl+X, then Y, then Enter).

### Step 2: Deploy First Agent (Test)

Deploy the Innovation Strategist to test everything works:

```bash
bash deploy-agent.sh 01
```

**What happens:**
- Creates EC2 instance in us-east-1
- Installs dependencies
- Starts the agent
- Takes ~2-3 minutes

**Expected output:**
```
🚀 Deploying Agent 01
================================
Agent ID: innovation-strategist-01
Agent Name: Innovation Catalyst
Domain: innovation strategy and ideation
Port: 6001
Region: us-east-1

[AWS deployment output...]

🎉 NANDA Agent Deployment Complete!
==================================
Instance ID: i-0abc123def456...
Public IP: 54.123.45.67
Agent URL: http://54.123.45.67:6001/a2a
```

**Save the Public IP** - you'll need it for testing!

### Step 3: Test First Agent

Wait 2-3 minutes after deployment, then test:

```bash
# Replace IP with your actual agent IP
curl -X POST http://54.123.45.67:6001/a2a \
  -H "Content-Type: application/json" \
  -d '{"content":{"text":"Hello! Can you generate a creative AI agent project idea?","type":"text"},"role":"user","conversation_id":"test123"}'
```

**Expected:** JSON response with agent's answer.

**If it fails:** Wait another minute and try again. Agent may still be initializing.

### Step 4: Take Screenshot for Assignment

Take a screenshot of your terminal showing:
- The deployment command
- The successful deployment output with Public IP
- (Optional) The test curl command and response

**This is your homework deliverable!**

### Step 5: Deploy Remaining Agents (Optional)

If you want the full 10-agent team:

```bash
# Deploy all remaining agents (02-10)
for i in {02..10}; do
    bash deploy-agent.sh $(printf "%02d" $i)
    sleep 10  # Wait between deployments
done
```

**Time:** ~20-25 minutes for 9 agents

**Alternative - Deploy all at once:**
```bash
bash deploy-all-agents.sh
```

### Step 6: Collect Agent IPs

After deploying multiple agents, collect their IPs:

```bash
# Check AWS console or use AWS CLI
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=tag:Project,Values=NANDA-Streamlined" \
  --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],PublicIpAddress,State.Name]' \
  --output table
```

Create `deployments/agent-ips.txt` from the template:

```bash
cp deployments/agent-ips.txt.template deployments/agent-ips.txt
nano deployments/agent-ips.txt
```

Fill in the IPs for each agent.

### Step 7: Run A2A Simulation (Optional)

Test agent-to-agent communication:

```bash
bash simulate-evaluation.sh
```

This sends a startup idea through all 10 agents and measures:
- Mean latency
- P95 latency
- Success rate

Results saved to `simulations/simulation-TIMESTAMP.log`

## Project Structure

```
NEST-agent/
├── agents/                          # Agent configurations (10 .env files)
├── deployments/                     # Deployment logs and IPs
├── simulations/                     # Simulation results
├── NEST/                           # NEST repository (you clone this)
├── shared-config.env               # Your API key goes here
├── deploy-agent.sh                 # Deploy single agent
├── deploy-all-agents.sh            # Deploy all agents
├── simulate-evaluation.sh          # A2A simulation
├── TEAM-STRUCTURE.md              # Team documentation
└── QUICK-START.md                 # This file
```

## Common Commands

### Deployment
```bash
# Deploy specific agent
bash deploy-agent.sh 01

# Deploy all agents
bash deploy-all-agents.sh

# Check deployment logs
cat deployments/agent-01-deployment.log
```

### Testing Individual Agent
```bash
# Replace IP and PORT with your agent's values
curl -X POST http://[IP]:[PORT]/a2a \
  -H "Content-Type: application/json" \
  -d '{"content":{"text":"Your message here","type":"text"},"role":"user","conversation_id":"test123"}'
```

### AWS Management
```bash
# List all running instances
aws ec2 describe-instances --region us-east-1 --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' --output table

# SSH into an agent instance
ssh -i NEST/nanda-agent-key.pem ubuntu@[AGENT_IP]

# Check agent logs on EC2
ssh -i NEST/nanda-agent-key.pem ubuntu@[AGENT_IP]
tail -f nanda-agent-*/agent.log

# Terminate specific instance
aws ec2 terminate-instances --region us-east-1 --instance-ids i-0abc123def456

# Terminate all NANDA agents
aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Project,Values=NANDA-Streamlined" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].InstanceId' --output text | xargs aws ec2 terminate-instances --region us-east-1 --instance-ids
```

## Troubleshooting

### "AWS credentials not configured"
```bash
aws configure
# Enter your Access Key, Secret Key, region (us-east-1), output (json)
```

### "ANTHROPIC_API_KEY not set"
Edit `shared-config.env` and add your API key.

### "NEST directory not found"
```bash
git clone https://github.com/projnanda/NEST.git
```

### Agent not responding
- Wait 2-3 minutes after deployment for full initialization
- Check if instance is running: `aws ec2 describe-instances --region us-east-1`
- SSH into instance and check logs: `tail -f nanda-agent-*/agent.log`

### Deployment fails
- Check AWS CLI configuration: `aws configure list`
- Verify IAM permissions include EC2FullAccess
- Check AWS service limits for EC2 instances

## Cost Estimate

**Single Agent (t3.micro):**
- $0.0104/hour = ~$0.25/day = ~$7.50/month

**10 Agents:**
- ~$2.50/day = ~$75/month if running 24/7

**For Assignment:**
- Test for 1-2 hours: ~$0.10
- Remember to terminate instances when done!

## What's Next?

After successful deployment:

1. ✅ Screenshot for homework submission
2. 📊 (Optional) Run A2A simulation and document results
3. 💡 Use the team to evaluate your course project ideas!
4. 🧹 Remember to terminate instances when done

## Need Help?

- Check NEST documentation: https://github.com/projnanda/NEST
- Review TEAM-STRUCTURE.md for agent details
- Check deployments/ folder for logs
