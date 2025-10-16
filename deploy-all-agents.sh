#!/bin/bash

# Deploy All Agents Sequentially
# This script deploys all 10 agents one by one

set -e

echo "🚀 Deploying All 10 Agents"
echo "=========================="
echo ""
echo "This will deploy agents 01 through 10 sequentially."
echo "Each deployment takes ~2-3 minutes."
echo "Total estimated time: ~20-30 minutes"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 0
fi

# Deploy each agent
for i in $(seq -f "%02g" 1 10); do
    echo ""
    echo "=========================================="
    echo "Deploying Agent $i of 10"
    echo "=========================================="
    bash deploy-agent.sh "$i"

    # Wait a bit between deployments to avoid AWS rate limits
    if [ "$i" != "10" ]; then
        echo ""
        echo "⏳ Waiting 10 seconds before next deployment..."
        sleep 10
    fi
done

echo ""
echo "🎉 All 10 agents deployed!"
echo ""
echo "📊 Deployment Summary:"
ls -1 deployments/agent-*-deployment.log | while read log; do
    agent_id=$(grep "Agent ID:" "$log" | cut -d' ' -f3)
    port=$(grep "Port:" "$log" | cut -d' ' -f2)
    echo "  ✓ $agent_id (port: $port)"
done
