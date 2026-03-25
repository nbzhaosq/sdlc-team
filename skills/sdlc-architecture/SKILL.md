---
name: sdlc:architecture
aliases: ["sdlc:design", "sdlc:arch"]
description: Architecture Design phase skill (Phase 2 of SDLC)
---

# Architecture Design Phase

## Overview
Transform requirements into a comprehensive system architecture design that defines the structure, components, interfaces, and technology stack of the system.

## Input
- `docs/sdlc/requirements.md` - Requirements specification from Phase 1

## Output
- `docs/sdlc/architecture.md` - Complete architecture design document

## Checklist
Before marking this phase complete, ensure:
- [ ] Component diagram created
- [ ] API endpoints defined
- [ ] Data models designed
- [ ] Security considerations addressed
- [ ] Scalability plan documented

## Responsibilities

### Interactive Confirmation (IMPORTANT)
- **Validate with user**: When making significant architectural decisions (tech stack, patterns, trade-offs), present options to the user and get confirmation
- **Mid-design check-ins**: Before committing to major design choices, explain the implications and get user buy-in
- **Final review**: After completing the architecture document, walk through the key design decisions with the user and get explicit approval
- **Explain trade-offs**: When presenting options, clearly explain pros/cons so the user can make informed decisions

### System Architecture Design
- Design overall system architecture and component interactions
- Define system boundaries and module responsibilities
- Document component relationships and dependencies
- Create architectural diagrams showing high-level structure

### Technology Stack Selection
- Evaluate and select appropriate technologies
- Consider team expertise, project constraints, and requirements
- Document rationale for technology choices
- Identify any third-party dependencies

### API Contract Definition
- Define all API endpoints with clear specifications
- Document request/response formats
- Specify authentication and authorization requirements
- Define error handling standards
- Document rate limiting and throttling policies

### Data Model Design
- Design database schemas and data structures
- Define entity relationships and constraints
- Document data validation rules
- Consider data migration and versioning strategy

### Security Considerations
- Identify security requirements and threats
- Define authentication and authorization mechanisms
- Document data encryption requirements (at rest, in transit)
- Plan for secrets management
- Address common security vulnerabilities (OWASP Top 10)

### Scalability Planning
- Define scaling strategy (vertical/horizontal)
- Document performance targets and SLAs
- Plan for load balancing and caching
- Consider disaster recovery and high availability
- Define monitoring and observability requirements

## Process

1. **Read Requirements**
   - Load `docs/sdlc/requirements.md`
   - Understand functional and non-functional requirements
   - Identify constraints and dependencies

2. **Design Architecture**
   - Create component diagram
   - Define component interfaces
   - Document data flow

3. **Select Technology Stack**
   - Evaluate options against requirements
   - Document decisions and rationale

4. **Define APIs**
   - List all endpoints
   - Document request/response schemas
   - Define authentication approach

5. **Design Data Models**
   - Create entity-relationship diagram
   - Define schemas and relationships
   - Document validation rules

6. **Address Cross-Cutting Concerns**
   - Security architecture
   - Scalability approach
   - Monitoring and observability

7. **Generate Document**
   - Write complete architecture document to `docs/sdlc/architecture.md`
   - Use the provided template for structure
   - Ensure all checklist items are addressed

8. **User Confirmation Gate**
   - Present architecture summary to user
   - Explain key design decisions and their rationale
   - Highlight any trade-offs or risks
   - Get explicit user approval before marking phase complete
   - Address any feedback or concerns raised by user
