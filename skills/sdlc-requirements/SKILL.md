---
name: sdlc:requirements
aliases: ["sdlc:analyze", "sdlc:req"]
phase: 1
---

# SDLC Requirements Analysis

Phase 1 of SDLC: Transform user feature requests or problem statements into well-defined requirements.

## Input

User's feature request or problem statement (can be informal description, ticket, or brief summary)

## Output

`docs/sdlc/requirements.md` - Structured requirements document

## Checklist

- [ ] User stories defined
- [ ] Acceptance criteria measurable
- [ ] Edge cases identified
- [ ] Dependencies mapped
- [ ] Priority assigned

## Responsibilities

### Extract Functional Requirements
- Identify what the system must do
- Define user actions and system responses
- Map user workflows and use cases

### Identify Non-Functional Requirements
- Performance requirements (response time, throughput)
- Security requirements (authentication, authorization, data protection)
- Scalability requirements (concurrent users, data volume)
- Reliability and availability targets
- Compliance and regulatory requirements

### Define Acceptance Criteria
- Write clear, testable criteria for each requirement
- Include "given-when-then" format where applicable
- Define success metrics and measurable outcomes

### Clarify Ambiguities
- Ask targeted questions to resolve unclear requirements
- Identify assumptions being made
- Flag areas needing stakeholder input

### Document Assumptions and Constraints
- Technical constraints (technology stack, legacy systems)
- Business constraints (deadlines, budget, resources)
- Assumptions about user behavior, data, or environment

## Usage

```
/sdlc:analyze Implement user authentication with OAuth2
```

or

```
/sdlc:requirements We need to add a dashboard for reporting
```

## Template

Requirements documents follow the template in `references/requirements-template.md`

## Validation

Run `scripts/validate-requirements.sh` to verify the requirements document is complete before proceeding to design.
