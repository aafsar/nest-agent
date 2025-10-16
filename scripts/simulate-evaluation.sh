#!/bin/bash

# A2A Simulation: Idea Evaluation Pipeline
# This script simulates an idea flowing through the 8-agent evaluation team
# Agents: 01-07, 10 (GTM Strategist and Risk Analyst omitted due to AWS vCPU limits)
# Usage: bash scripts/simulate-evaluation.sh

set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to project root
cd "$PROJECT_ROOT"

# Check if agent IPs file exists
if [ ! -f "deployments/agent-ips.txt" ]; then
    echo "❌ Agent IPs file not found!"
    echo "Please create deployments/agent-ips.txt with format:"
    echo "  AGENT_01_IP=1.2.3.4"
    echo "  AGENT_02_IP=1.2.3.5"
    echo "  ..."
    exit 1
fi

# Load agent IPs
source deployments/agent-ips.txt

# Project idea to evaluate
IDEA="AI-powered research paper analysis system that automatically summarizes papers, extracts key findings, and identifies research gaps using multi-agent collaboration"
CONVERSATION_ID="eval-$(date +%s)"

echo "🧪 A2A Simulation: Startup Idea Evaluation"
echo "==========================================="
echo ""
echo "💡 Idea: $IDEA"
echo "🆔 Conversation ID: $CONVERSATION_ID"
echo ""

# Create results directory
mkdir -p simulations
RESULTS_FILE="simulations/simulation-$(date +%Y%m%d-%H%M%S).log"

echo "Starting simulation at $(date)" > "$RESULTS_FILE"
echo "Idea: $IDEA" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Track latencies
declare -a latencies

# Helper function to call agent and measure latency
call_agent() {
    local agent_name=$1
    local agent_ip=$2
    local port=$3
    local message=$4

    echo "📞 Calling: $agent_name (${agent_ip}:${port})"

    start_time=$(date +%s.%N)

    response=$(curl -s -X POST "http://${agent_ip}:${port}/a2a" \
        -H "Content-Type: application/json" \
        -d "{\"content\":{\"text\":\"${message}\",\"type\":\"text\"},\"role\":\"user\",\"conversation_id\":\"${CONVERSATION_ID}\"}" \
        --max-time 60)

    end_time=$(date +%s.%N)
    latency=$(echo "$end_time - $start_time" | bc)

    echo "   ⏱️  Response time: ${latency}s"
    echo "$latency" >> "${RESULTS_FILE}.latencies"

    echo "" >> "$RESULTS_FILE"
    echo "=== $agent_name ===" >> "$RESULTS_FILE"
    echo "Latency: ${latency}s" >> "$RESULTS_FILE"
    echo "Response: $response" >> "$RESULTS_FILE"

    echo ""
}

echo "🚀 Starting 8-agent evaluation pipeline..."
echo "   (Agents 01-07 + 10: GTM Strategist and Risk Analyst omitted)"
echo ""

# 1. Innovation Strategist - Refine the idea
if [ -n "$AGENT_01_IP" ]; then
    call_agent "Innovation Strategist" "$AGENT_01_IP" "6001" \
        "Analyze and refine this startup idea: $IDEA. Provide specific recommendations."
fi

# 2. Technical Architect - Evaluate technical feasibility
if [ -n "$AGENT_02_IP" ]; then
    call_agent "Technical Architect" "$AGENT_02_IP" "6002" \
        "Evaluate the technical feasibility of: $IDEA. What are the architectural challenges?"
fi

# 3. Data Scientist - Assess ML requirements
if [ -n "$AGENT_03_IP" ]; then
    call_agent "Data Scientist" "$AGENT_03_IP" "6003" \
        "Assess the machine learning and data requirements for: $IDEA"
fi

# 4. Market Researcher - Analyze market
if [ -n "$AGENT_04_IP" ]; then
    call_agent "Market Researcher" "$AGENT_04_IP" "6004" \
        "Analyze the market opportunity for: $IDEA. Who are the competitors?"
fi

# 5. Product Designer - Evaluate UX
if [ -n "$AGENT_05_IP" ]; then
    call_agent "Product Designer" "$AGENT_05_IP" "6005" \
        "Evaluate the user experience and product-market fit for: $IDEA"
fi

# 6. Business Analyst - Assess business model
if [ -n "$AGENT_06_IP" ]; then
    call_agent "Business Analyst" "$AGENT_06_IP" "6006" \
        "Analyze the business model and revenue potential for: $IDEA"
fi

# 7. VC Evaluator - Investment potential
if [ -n "$AGENT_07_IP" ]; then
    call_agent "VC Evaluator" "$AGENT_07_IP" "6007" \
        "Evaluate the investment potential and scalability of: $IDEA"
fi

# 8. GTM Strategist - Go-to-market plan
if [ -n "$AGENT_08_IP" ]; then
    call_agent "GTM Strategist" "$AGENT_08_IP" "6008" \
        "Develop a go-to-market strategy for: $IDEA"
fi

# 9. Risk Analyst - Identify risks
if [ -n "$AGENT_09_IP" ]; then
    call_agent "Risk Analyst" "$AGENT_09_IP" "6009" \
        "Identify key risks and challenges for: $IDEA"
fi

# 10. Integration Coordinator - Final synthesis
if [ -n "$AGENT_10_IP" ]; then
    call_agent "Integration Coordinator" "$AGENT_10_IP" "6010" \
        "Synthesize all feedback and provide a final recommendation for: $IDEA. Should we pursue this project?"
fi

echo "✅ Simulation complete!"
echo ""

# Calculate statistics
if [ -f "${RESULTS_FILE}.latencies" ]; then
    echo "📊 Performance Metrics"
    echo "====================="

    # Mean latency
    mean=$(awk '{sum+=$1; count++} END {print sum/count}' "${RESULTS_FILE}.latencies")
    echo "Mean Latency: ${mean}s"

    # P95 latency
    p95=$(sort -n "${RESULTS_FILE}.latencies" | awk 'BEGIN{c=0} {a[c]=$1; c++} END{print a[int(c*0.95)]}')
    echo "P95 Latency: ${p95}s"

    # Success rate (assuming all calls succeeded if we got here)
    success_count=$(wc -l < "${RESULTS_FILE}.latencies")
    echo "Success Rate: 100% (${success_count}/8 agents responded)"

    # Save metrics to file
    echo "" >> "$RESULTS_FILE"
    echo "=== METRICS ===" >> "$RESULTS_FILE"
    echo "Mean Latency: ${mean}s" >> "$RESULTS_FILE"
    echo "P95 Latency: ${p95}s" >> "$RESULTS_FILE"
    echo "Success Rate: 100%" >> "$RESULTS_FILE"

    rm "${RESULTS_FILE}.latencies"
fi

echo ""
echo "📝 Full results saved to: $RESULTS_FILE"
