# NEST Agent Deployment

8-agent startup evaluation system for generating and assessing AI project ideas through multi-agent collaboration.

## Overview

This project deploys a team of specialized AI agents to NEST (NANDA Sandbox & Testbed) on AWS infrastructure. The agents collaborate via A2A (agent-to-agent) messaging to evaluate startup ideas from multiple perspectives: technical feasibility, business viability, market opportunity, and more.

## Features

- **8 Specialized Agents:** Innovation, Technical, Data Science, Market, Product, Business, VC, Integration
- **A2A Communication:** Real-time agent-to-agent messaging via NEST registry
- **AWS Deployment:** Automated EC2 instance provisioning and configuration
- **Performance Metrics:** Mean latency 3.33s, P95 4.0s, 100% success rate
- **Comprehensive Evaluation:** Multi-dimensional analysis of project ideas

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
# 1. Set your Anthropic API key
echo 'ANTHROPIC_API_KEY="your-key-here"' > shared-config.env

# 2. Clone NEST repository
git clone https://github.com/projnanda/NEST.git

# 3. Deploy an agent
bash scripts/deploy-agent.sh 01

# 4. Run A2A simulation (after all agents deployed)
bash scripts/simulate-evaluation.sh
```

For detailed instructions, see [docs/QUICK-START.md](docs/QUICK-START.md).

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

## Project Structure

```
nest-agent/
├── agents/                     # Agent configuration files (10 agents)
├── scripts/                    # Deployment and simulation scripts
│   ├── deploy-agent.sh        # Deploy single agent
│   ├── deploy-all-agents.sh   # Deploy all agents
│   ├── collect-agent-ips.sh   # Collect agent IPs from AWS
│   └── simulate-evaluation.sh # Run A2A simulation
├── docs/                       # Documentation
│   ├── QUICK-START.md         # Step-by-step deployment guide
│   ├── TEAM-STRUCTURE.md      # Agent roles and workflow
│   ├── SIMULATION-RESULTS.md  # Performance metrics and analysis
│   ├── A2A-PERFORMANCE-METRICS.md  # Concise performance summary
│   └── AUTONOMOUS-IDEATION-SYSTEM.md  # Future 15-agent design
├── deployments/                # Deployment artifacts
└── simulations/                # Simulation results
```

## Documentation

- **[Quick Start Guide](docs/QUICK-START.md)** - Complete deployment instructions
- **[Team Structure](docs/TEAM-STRUCTURE.md)** - Agent roles and interaction patterns
- **[Simulation Results](docs/SIMULATION-RESULTS.md)** - Performance analysis and findings
- **[Performance Metrics](docs/A2A-PERFORMANCE-METRICS.md)** - A2A communication metrics

## License

MIT
