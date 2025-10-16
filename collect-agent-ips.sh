#!/bin/bash

# Collect Agent IPs from AWS
# This script queries AWS for deployed agent IPs and creates agent-ips.txt

set -e

REGION="us-east-1"
OUTPUT_FILE="deployments/agent-ips.txt"

echo "🔍 Collecting agent IPs from AWS..."
echo ""

# Get all NANDA agent instances
instances=$(aws ec2 describe-instances \
    --region "$REGION" \
    --filters "Name=tag:Project,Values=NANDA-Streamlined" "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],PublicIpAddress]' \
    --output text)

if [ -z "$instances" ]; then
    echo "❌ No running NANDA agents found in $REGION"
    exit 1
fi

# Create the IPs file
echo "# Agent IP Addresses - Auto-generated on $(date)" > "$OUTPUT_FILE"
echo "# Region: $REGION" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Parse and format the output
echo "$instances" | while read -r name ip; do
    if [[ $name =~ nanda-agent-.*-([0-9]+) ]]; then
        agent_num="${BASH_REMATCH[1]}"
        agent_id=$(echo "$name" | sed 's/nanda-agent-//')
        echo "AGENT_${agent_num}_IP=$ip" >> "$OUTPUT_FILE"
        echo "✓ Agent $agent_num ($agent_id): $ip"
    fi
done

echo ""
echo "✅ Agent IPs saved to: $OUTPUT_FILE"
echo ""
echo "📋 Summary:"
cat "$OUTPUT_FILE"
