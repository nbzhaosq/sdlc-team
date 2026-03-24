---
name: pipeline-config
description: Default SDLC pipeline configuration
---

# SDLC Pipeline Configuration

Default configuration for the SDLC coordinator skill. Override these settings in your project's `CLAUDE.md` file.

## Phase Execution Order

```
requirements -> architecture -> development -> review -> testing
```

## Artifact Paths

| Phase | Artifact Path | Description |
|-------|---------------|-------------|
| requirements | `docs/sdlc/requirements.md` | Requirements document |
| architecture | `docs/sdlc/architecture.md` | Architecture design |
| development | *varies* | Implementation files |
| review | `docs/sdlc/review.md` | Code review notes |
| testing | `docs/sdlc/test-report.md` | Test results and coverage |

## Phase Settings

### Requirements
- **Output Format**: Markdown with user story template
- **Required Sections**: Overview, User Stories, Acceptance Criteria, Dependencies, Constraints
- **Validation**: All acceptance criteria must be testable

### Architecture
- **Output Format**: Markdown with diagrams (ASCII/Mermaid)
- **Required Sections**: System Overview, Components, Data Model, API Contracts, Technology Decisions
- **Validation**: Must address all requirements from prior phase

### Development
- **Code Standards**: Project-specific (define in CLAUDE.md)
- **Testing**: Unit tests required for all new code
- **Documentation**: Inline comments for complex logic

### Review
- **Checklist**: Requirements alignment, architecture adherence, security, performance, maintainability
- **Approval**: Requires manual sign-off or automated criteria satisfaction
- **Output**: Pass/Fail with specific feedback

### Testing
- **Types**: Unit, integration, end-to-end
- **Coverage**: Minimum 80% line coverage (configurable)
- **CI Integration**: Runs in automated pipeline

## State File

Location: `.sdlc-state.json` (project root)

Auto-generated on first execution. Do not manually edit during active pipeline runs.

## CLI Overrides

These defaults can be overridden via CLAUDE.md:

```markdown
## SDLC Configuration

sdlc:
  requirements:
    output: docs/my-requirements.md
    template: custom-template.md
  architecture:
    include_diagrams: true
    diagram_format: mermaid
  testing:
    min_coverage: 90
    types: [unit, integration, e2e]
```
