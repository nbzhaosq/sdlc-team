---
name: sdlc
aliases: ["sdlc:run", "sdlc:pipeline"]
description: SDLC coordinator skill that orchestrates all 5 phases of software development lifecycle
user_invocable: true
---

# SDLC Coordinator Skill

Orchestrates the complete Software Development Lifecycle through 5 phases: Requirements, Architecture, Development, Review, and Testing.

## Commands

### Run Full Pipeline
```
/sdlc "feature description"
```
Executes all 5 phases in sequence from requirements through testing.

### Resume from Phase
```
/sdlc --resume <phase>
```
Resumes execution from a specific phase (requires valid state file).
Valid phases: `requirements`, `architecture`, `development`, `review`, `testing`

### Run Single Phase
```
/sdlc --phase <phase>
```
Executes only the specified phase without running the full pipeline.
Valid phases: `requirements`, `architecture`, `development`, `review`, `testing`

### Dry Run
```
/sdlc --dry-run
```
Validates inputs and configuration without executing any phases.

### Individual Phase Commands

Each phase can also be invoked directly with its own command:

| Command | Phase |
|---------|-------|
| `/sdlc:analyze` or `/sdlc:req` | Phase 1: Requirements |
| `/sdlc:design` or `/sdlc:arch` | Phase 2: Architecture |
| `/sdlc:develop` or `/sdlc:code` | Phase 3: Development |
| `/sdlc:review` | Phase 4: Code Review |
| `/sdlc:test` or `/sdlc:verify` | Phase 5: Testing |

## Pipeline Phases

### 1. Requirements Phase
- Elicits functional and non-functional requirements
- Documents user stories and acceptance criteria
- Identifies dependencies and constraints
- Output: `docs/sdlc/requirements.md`

### 2. Architecture Phase
- Designs system architecture and data models
- Defines interfaces and API contracts
- Identifies technical decisions and trade-offs
- Output: `docs/sdlc/architecture.md`

### 3. Development Phase
- Implements features according to architecture
- Writes code with appropriate structure and patterns
- Follows project coding standards
- Output: Implementation files per project structure

### 4. Review Phase
- Conducts code review against requirements
- Validates adherence to architecture
- Checks for security, performance, and maintainability
- Output: Review comments and approval notes

### 5. Testing Phase
- Creates and executes test cases
- Validates against acceptance criteria
- Reports test coverage and results
- Output: Test reports and coverage metrics

## State Management

State is persisted in `.sdlc-state.json` in the project root:

```json
{
  "project": "feature-name",
  "current_phase": "development",
  "phases": {
    "requirements": { "status": "completed", "completed_at": "ISO timestamp" },
    "architecture": { "status": "completed", "completed_at": "ISO timestamp" },
    "development": { "status": "in_progress", "started_at": "ISO timestamp" },
    "review": { "status": "pending" },
    "testing": { "status": "pending" }
  },
  "artifacts": {
    "requirements": "docs/sdlc/requirements.md",
    "architecture": "docs/sdlc/architecture.md"
  }
}
```

## Configuration

Default configuration in `skills/sdlc/references/pipeline-config.md` can be overridden via project `CLAUDE.md`.

## Error Handling

- Missing artifacts from prior phases trigger phase re-execution
- Phase failures halt the pipeline with clear error messages
- State file corruption triggers recovery mode
- Validation errors prevent phase start

## Phase Handoff

Each phase validates artifacts from previous phases before execution:
- Architecture requires completed requirements
- Development requires completed architecture
- Review requires completed development
- Testing requires completed review

## Usage

To execute the full SDLC pipeline:
1. Invoke with `/sdlc "your feature description"`
2. Monitor progress through phase completion messages
3. Review artifacts in `docs/sdlc/` directory
4. Use `--resume` to continue if interrupted
5. Use `--phase` to iterate on specific steps
