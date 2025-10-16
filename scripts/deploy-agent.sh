#!/bin/bash

# Single Agent Deployment Script
# Usage: bash scripts/deploy-agent.sh <agent-number>
# Example: bash scripts/deploy-agent.sh 01

set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to project root
cd "$PROJECT_ROOT"

# Check if agent number is provided
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <agent-number>"
    echo ""
    echo "Available agents:"
    ls -1 agents/ | grep "agent-" | sed 's/agent-/  /' | sed 's/.env//'
    echo ""
    echo "Example: $0 01"
    exit 1
fi

AGENT_NUM="$1"
AGENT_CONFIG="agents/agent-${AGENT_NUM}-*.env"

# Find the agent config file
CONFIG_FILE=$(ls $AGENT_CONFIG 2>/dev/null | head -1)

if [ -z "$CONFIG_FILE" ]; then
    echo "❌ Agent config not found: $AGENT_CONFIG"
    echo ""
    echo "Available agents:"
    ls -1 agents/ | grep "agent-" | sed 's/agent-/  /' | sed 's/.env//'
    exit 1
fi

echo "📋 Loading configuration from: $CONFIG_FILE"

# Load shared config
if [ -f "shared-config.env" ]; then
    source shared-config.env
else
    echo "❌ shared-config.env not found!"
    exit 1
fi

# Load agent-specific config
source "$CONFIG_FILE"

# Validate API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ ANTHROPIC_API_KEY not set in shared-config.env"
    echo "Please edit shared-config.env and add your API key"
    exit 1
fi

# Check if NEST directory exists
if [ ! -d "$NEST_PATH" ]; then
    echo "❌ NEST directory not found at: $NEST_PATH"
    echo "Please clone NEST repository first:"
    echo "  git clone https://github.com/projnanda/NEST.git"
    exit 1
fi

echo ""
echo "🚀 Deploying Agent ${AGENT_NUM}"
echo "================================"
echo "Agent ID: $AGENT_ID"
echo "Agent Name: $AGENT_NAME"
echo "Domain: $DOMAIN"
echo "Port: $PORT"
echo "Region: $REGION"
echo ""

# Navigate to NEST directory and run deployment
cd "$NEST_PATH"

bash scripts/aws-single-agent-deployment.sh \
  "$AGENT_ID" \
  "$ANTHROPIC_API_KEY" \
  "$AGENT_NAME" \
  "$DOMAIN" \
  "$SPECIALIZATION" \
  "$DESCRIPTION" \
  "$CAPABILITIES" \
  "$REGISTRY_URL" \
  "$PORT" \
  "$REGION" \
  "$INSTANCE_TYPE"

# Return to project directory
cd ..

# Save deployment info
DEPLOYMENT_LOG="deployments/agent-${AGENT_NUM}-deployment.log"
mkdir -p deployments
echo "Deployed at: $(date)" > "$DEPLOYMENT_LOG"
echo "Agent ID: $AGENT_ID" >> "$DEPLOYMENT_LOG"
echo "Port: $PORT" >> "$DEPLOYMENT_LOG"

echo ""
echo "✅ Agent ${AGENT_NUM} deployment initiated!"
echo "📝 Deployment log saved to: $DEPLOYMENT_LOG"
