# NEST Agent Deployment

Autonomous agent deployment to NEST (NANDA Sandbox & Testbed) on AWS infrastructure.

## Overview

NEST (NANDA Sandbox & Testbed) is a lightweight environment for running and observing autonomous agents in real time. It provides registry/routing for agent discovery and A2A (agent-to-agent) message exchange, along with orchestration hooks for liveness validation and coordination.

## Features

- AWS EC2 deployment infrastructure
- Agent-to-agent communication via NEST registry
- Real-time agent orchestration and monitoring
- Liveness validation and coordination protocols

## Resources

- **NEST Demo:** [https://index.projectnanda.org/](https://index.projectnanda.org/)
- **NEST Repository:** [https://github.com/projnanda/NEST.git](https://github.com/projnanda/NEST.git)

## Prerequisites

- AWS CLI configured with appropriate credentials
- IAM user with EC2 access permissions
- Anthropic Claude API key
- AWS region configuration (e.g., us-east-1)

## Quick Start

```bash
# Clone NEST repository
git clone https://github.com/projnanda/NEST.git
cd NEST

# Deploy agent to AWS
bash scripts/aws-single-agent-deployment.sh \
  "agent-id" \
  "your-api-key" \
  "Agent Name" \
  "domain" \
  "specialization" \
  "description" \
  "capabilities" \
  "registry-url" \
  "port" \
  "region" \
  "instance-type"
```

## Configuration

The deployment script accepts the following parameters:
- `agent-id`: Unique identifier for the agent
- `api-key`: Anthropic Claude API key
- `name`: Display name for the agent
- `domain`: Field of expertise
- `specialization`: Role description
- `description`: Detailed agent description
- `capabilities`: Comma-separated list of capabilities
- `registry-url`: NEST registry URL
- `port`: Port number for agent communication
- `region`: AWS region (e.g., us-east-1)
- `instance-type`: EC2 instance type

## Documentation

Detailed deployment instructions and troubleshooting guides are available in the project documentation.

## License

MIT
