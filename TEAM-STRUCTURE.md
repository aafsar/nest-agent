# Startup Ideation & Evaluation Team

A cohesive agent team designed to generate and evaluate agent-related project ideas for both academic course projects and commercial startup potential.

## ⚠️ Current Configuration: 8-Agent Team

**Due to AWS vCPU limits (16 vCPU max), we deployed 8 agents instead of the originally planned 10:**
- **Deployed:** Agents 1-7, 10 (8 agents total)
- **Omitted:** Agent 8 (GTM Strategist), Agent 9 (Risk Analyst)
- **Rationale:** GTM Strategist's functions overlap with Market Researcher; Risk analysis can be covered by other domain experts

## Team Overview

This team collaborates through A2A (agent-to-agent) communication to provide comprehensive evaluation of project ideas from multiple perspectives:

### 🎯 Team Members

1. **Innovation Strategist** (Port 6001)
   - Role: Generates creative AI agent project ideas
   - Focus: Emerging trends, practical applications, real-world problems
   - Output: Novel project concepts with academic & commercial potential

2. **Technical Architect** (Port 6002)
   - Role: Evaluates technical feasibility
   - Focus: System architecture, implementation complexity, technical risks
   - Output: Architecture assessment, technology recommendations

3. **Data Scientist** (Port 6003)
   - Role: Analyzes AI/ML and data requirements
   - Focus: Model complexity, data availability, training needs
   - Output: ML feasibility assessment, data strategy

4. **Market Researcher** (Port 6004)
   - Role: Investigates market opportunities
   - Focus: Market size, competitors, customer segments
   - Output: Market analysis, TAM/SAM/SOM, competitive landscape

5. **Product Designer** (Port 6005)
   - Role: Evaluates user experience and product-market fit
   - Focus: User interaction, UX challenges, problem-solution fit
   - Output: Design assessment, PMF evaluation

6. **Business Analyst** (Port 6006)
   - Role: Analyzes business viability
   - Focus: Revenue models, unit economics, cost structure
   - Output: Business model evaluation, financial projections

7. **VC Evaluator** (Port 6007)
   - Role: Assesses investment potential
   - Focus: Scalability, competitive moats, exit potential
   - Output: Investment thesis, venture potential rating

8. **GTM Strategist** (Port 6008)
   - Role: Plans market entry strategy
   - Focus: Customer acquisition, marketing channels, launch plan
   - Output: GTM strategy, growth roadmap

9. **Risk Analyst** (Port 6009)
   - Role: Identifies risks and challenges
   - Focus: Technical, business, legal, regulatory risks
   - Output: Risk assessment, mitigation strategies

10. **Integration Coordinator** (Port 6010)
    - Role: Synthesizes all feedback
    - Focus: Pattern recognition, conflict resolution, final recommendations
    - Output: Comprehensive evaluation report with go/no-go recommendation

## Workflow & Interaction Pattern (8-Agent Configuration)

```
Innovation Strategist (generates idea)
        ↓
    [Parallel Evaluation]
        ↓
┌───────┴───────┬───────────┬───────────┐
↓               ↓           ↓           ↓
Technical       Data        Market      Product
Architect       Scientist   Researcher  Designer
↓               ↓           ↓           ↓
└───────┬───────┴───────────┴───────────┘
        ↓
Business Analyst ← validates → VC Evaluator
        ↓                              ↓
        └──────────┬───────────────────┘
                   ↓
        Integration Coordinator
                   ↓
        Final Recommendation
```

**Note:** GTM Strategist and Risk Analyst omitted due to AWS limits. Their functions are partially covered by Market Researcher and other evaluators.

## Use Cases

### 1. Course Project Ideation
Use the team to generate and evaluate agent-based project ideas for MIT AI Studio course requirements.

### 2. Startup Validation
Evaluate potential startup ideas with commercial viability assessment.

### 3. Multi-Agent Collaboration Demo
Demonstrate A2A communication and agent coordination in a real-world scenario.

### 4. Decision Support System
Use as a comprehensive evaluation framework for any agent-related project decision.

## Deployment

### Deploy Single Agent (Test First)
```bash
# 1. Set your API key in shared-config.env
nano shared-config.env

# 2. Deploy agent 01 (Innovation Strategist)
bash deploy-agent.sh 01
```

### Deploy All Agents
```bash
# Deploy all 10 agents sequentially
bash deploy-all-agents.sh
```

### Deploy Specific Agents
```bash
# Deploy just the evaluation core (2-10)
for i in {02..10}; do
    bash deploy-agent.sh $(printf "%02d" $i)
    sleep 10
done
```

## Testing A2A Communication

### Example: Idea Generation & Evaluation Flow

1. **Send idea to Innovation Strategist:**
```bash
curl -X POST http://[IP]:6001/a2a \
  -H "Content-Type: application/json" \
  -d '{
    "content": {"text": "Generate an agent-based project idea for automating research paper analysis", "type": "text"},
    "role": "user",
    "conversation_id": "eval001"
  }'
```

2. **Route to Technical Architect for evaluation:**
```bash
curl -X POST http://[IP]:6002/a2a \
  -H "Content-Type: application/json" \
  -d '{
    "content": {"text": "@technical-architect-02 Please evaluate the technical feasibility of [idea from step 1]", "type": "text"},
    "role": "user",
    "conversation_id": "eval001"
  }'
```

3. **Continue chain through all evaluators...**

4. **Final synthesis:**
```bash
curl -X POST http://[IP]:6010/a2a \
  -H "Content-Type: application/json" \
  -d '{
    "content": {"text": "@integration-coordinator-10 Please synthesize all feedback and provide final recommendation", "type": "text"},
    "role": "user",
    "conversation_id": "eval001"
  }'
```

## Evaluation Metrics

When running A2A simulations, measure:

- **Mean Latency**: Average response time across agent chain
- **P95 Latency**: 95th percentile response time
- **Success Rate**: Percentage of successful A2A communications
- **Evaluation Completeness**: How many evaluation dimensions were covered

## Agent Port Mapping

| Agent | Port | Agent ID | Status |
|-------|------|----------|--------|
| Innovation Strategist | 6001 | innovation-strategist-01 | ✅ Deployed |
| Technical Architect | 6002 | technical-architect-02 | ✅ Deployed |
| Data Scientist | 6003 | data-scientist-03 | ✅ Deployed |
| Market Researcher | 6004 | market-researcher-04 | ✅ Deployed |
| Product Designer | 6005 | product-designer-05 | ✅ Deployed |
| Business Analyst | 6006 | business-analyst-06 | ✅ Deployed |
| VC Evaluator | 6007 | vc-evaluator-07 | ✅ Deployed |
| ~~GTM Strategist~~ | ~~6008~~ | ~~gtm-strategist-08~~ | ❌ Omitted (vCPU limit) |
| ~~Risk Analyst~~ | ~~6009~~ | ~~risk-analyst-09~~ | ❌ Omitted (vCPU limit) |
| Integration Coordinator | 6010 | integration-coordinator-10 | ✅ Deployed |

## Notes

- **Current deployment:** 8 agents (01-07, 10) due to AWS vCPU limit of 16
- All agents use the same registry: `http://registry.chat39.com:6900`
- Agents run on AWS EC2 `t3.micro` instances in `us-east-1` (2 vCPUs each)
- Each agent has unique port to avoid conflicts
- Deploy agents sequentially to avoid AWS rate limits
- Wait ~2-3 minutes after each deployment for full initialization
- **Total vCPU usage:** 16 vCPUs (8 instances × 2 vCPUs)
