# SDLC Sub-Agent Team System

A complete software development lifecycle pipeline implemented as agent skills with structured handoffs, state management, and per-project customization.

## Quick Start

### 1. Initialize a New Project

```bash
# Run the initialization script (auto-detect AI tool)
./skills/sdlc-init/scripts/init-sdlc.sh /path/to/your/project

# Or specify a tool
./skills/sdlc-init/scripts/init-sdlc.sh /path/to/your/project claude
./skills/sdlc-init/scripts/init-sdlc.sh /path/to/your/project cursor
./skills/sdlc-init/scripts/init-sdlc.sh /path/to/your/project agents

# Or configure for all tools
./skills/sdlc-init/scripts/init-sdlc.sh /path/to/your/project all

# Or use the skill
/sdlc:init
```

### Supported AI Tools

| Tool | Config File | Description |
|------|-------------|-------------|
| Claude Code | `CLAUDE.md` | Primary support, full slash commands |
| Cursor | `.cursorrules` | Workflow guidance |
| Windsurf | `.windsurfrules` | Workflow guidance |
| Generic | `AGENTS.md` | Universal format for any AI tool |
| Aider | `.aider.conf.yml` | Limited support |

This creates:
- `docs/sdlc/` - Directory for phase artifacts
- `.sdlc/` - Customization directory (templates, scripts, standards)
- `.sdlc-state.json` - Pipeline state tracking
- `CLAUDE.md` - Project configuration with SDLC settings

### 2. Configure Project

Edit `CLAUDE.md` to customize:

```markdown
# SDLC Configuration

## Project Info
- **Name**: My Project
- **Tech Stack**: TypeScript, React, Node.js, PostgreSQL

## Testing Phase
- Commands: `npm test`, `npm run e2e`
- Coverage threshold: 80%
```

### 3. Run Pipeline

```bash
# Full pipeline
/sdlc "Build user authentication with OAuth"

# Single phase
/sdlc:analyze "Add dashboard feature"
/sdlc:design
/sdlc:develop
/sdlc:review
/sdlc:test
```

## Available Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `/sdlc:init` | `/sdlc-init` | Initialize project for SDLC |
| `/sdlc "feature"` | `/sdlc:run` | Run full 5-phase pipeline |
| `/sdlc --resume <phase>` | | Resume from specific phase |
| `/sdlc --phase <phase>` | | Run single phase only |
| `/sdlc:analyze "feature"` | `/sdlc:req` | Phase 1: Requirements Analysis |
| `/sdlc:design` | `/sdlc:arch` | Phase 2: Architecture Design |
| `/sdlc:develop` | `/sdlc:code`, `/sdlc:dev` | Phase 3: Implementation |
| `/sdlc:review` | `/sdlc:code-review` | Phase 4: Code Review |
| `/sdlc:test` | `/sdlc:verify` | Phase 5: Testing & Verification |

## Project Structure

```
your-project/
├── CLAUDE.md                    # Project config + SDLC settings
├── .sdlc-state.json             # Pipeline state tracking
├── docs/
│   └── sdlc/                    # Phase artifacts
│       ├── requirements.md
│       ├── architecture.md
│       ├── implementation-notes.md
│       ├── review-feedback.md
│       └── test-report.md
├── .sdlc/
│   ├── templates/               # Custom templates
│   ├── scripts/                 # Custom validation/test scripts
│   └── standards/               # Custom coding standards
└── skills/                      # SDLC skills (if embedded)
```

## Configuration

### CLAUDE.md Settings

```markdown
# SDLC Configuration

## Project Info
- **Name**: [Project Name]
- **Tech Stack**: [Languages, frameworks, databases]
- **Infrastructure**: [Cloud provider, deployment]

## Phase Customizations

### Requirements Phase
- Template: `.sdlc/templates/requirements-extended.md`
- Required sections: business-value, user-personas, success-metrics
- Stakeholders: [List who needs to approve]

### Architecture Phase
- Template: `.sdlc/templates/architecture-aws.md`
- Must include: cost-estimate, security-review, disaster-recovery
- Tech stack: TypeScript, React, Node.js, PostgreSQL, AWS

### Development Phase
- Coding standards: `.sdlc/standards/typescript.md`
- Test coverage minimum: 80%
- Required tests: unit, integration, e2e
- Branch strategy: feature branches → main

### Review Phase
- Checklist: OWASP-Top-10, accessibility (WCAG 2.1), performance
- Run before review: `npm run lint && npm run typecheck`
- Required approvals: 1 peer review

### Testing Phase
- Commands:
  - `npm test -- --coverage`
  - `npm run e2e`
  - `npm run lighthouse`
- Performance budget: LCP < 2.5s, FID < 100ms
- Coverage threshold: 80%
```

### Template Override

Default templates are in `skills/sdlc-*/references/`. Override them by:

1. Copy to `.sdlc/templates/`
2. Customize
3. Reference in CLAUDE.md

```bash
# Copy templates
cp skills/sdlc-requirements/references/requirements-template.md .sdlc/templates/

# Edit CLAUDE.md
### Requirements Phase
- Template: `.sdlc/templates/requirements-template.md`
```

### Script Override

Override validation scripts similarly:

```bash
cp skills/sdlc-review/scripts/run-linters.sh .sdlc/scripts/
chmod +x .sdlc/scripts/run-linters.sh
```

## Pipeline Flow

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Requirements│───▶│ Architecture │───▶│ Development │───▶│   Review    │───▶│   Testing   │
│   Phase 1   │    │   Phase 2    │    │   Phase 3   │    │   Phase 4   │    │   Phase 5   │
└──────┬──────┘    └──────┬───────┘    └──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                    │                  │                  │
       ▼                  ▼                    ▼                  ▼                  ▼
 requirements.md    architecture.md    implementation-    review-feedback.md  test-report.md
                                       notes.md + code
```

### State Tracking

Pipeline state is tracked in `.sdlc-state.json`:

```json
{
  "project": "user-auth",
  "current_phase": "development",
  "phases": {
    "requirements": { "status": "completed", "completed_at": "2025-03-25T10:00:00Z" },
    "architecture": { "status": "completed", "completed_at": "2025-03-25T11:30:00Z" },
    "development": { "status": "in_progress", "started_at": "2025-03-25T12:00:00Z" },
    "review": { "status": "pending" },
    "testing": { "status": "pending" }
  },
  "artifacts": {
    "requirements": "docs/sdlc/requirements.md",
    "architecture": "docs/sdlc/architecture.md"
  }
}
```

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Missing prior artifact | Prompt to run earlier phase or provide input |
| Phase failure | Halt pipeline, present error, await decision |
| Review finds issues | Return to development with specific feedback |
| Tests fail | Return to development with failure details |
| State corruption | Recovery mode - rebuild from artifacts |

## Examples

### Example 1: New Feature

```bash
# Start full pipeline for a new feature
/sdlc "Build user profile page with avatar upload"

# Pipeline will:
# 1. Generate requirements.md with user stories
# 2. Design architecture with API endpoints
# 3. Implement the feature
# 4. Review code quality and security
# 5. Run tests and verify acceptance criteria
```

### Example 2: Resume After Interruption

```bash
# Pipeline was interrupted during development
/sdlc --resume development

# Continues from development phase
# Uses existing requirements.md and architecture.md
```

### Example 3: Iteration

```bash
# Run only review phase after manual changes
/sdlc:review

# Or iterate on architecture without full pipeline
/sdlc:design
```

## Skills Reference

| Skill | Name | Aliases | Purpose |
|-------|------|---------|---------|
| Coordinator | `sdlc` | `sdlc:run`, `sdlc:pipeline` | Main coordinator |
| Init | `sdlc:init` | `sdlc-init` | Project initialization |
| Phase 1 | `sdlc:requirements` | `sdlc:analyze`, `sdlc:req` | Requirements Analysis |
| Phase 2 | `sdlc:architecture` | `sdlc:design`, `sdlc:arch` | Architecture Design |
| Phase 3 | `sdlc:development` | `sdlc:develop`, `sdlc:code` | Implementation |
| Phase 4 | `sdlc:review` | `sdlc:code-review` | Code Review |
| Phase 5 | `sdlc:testing` | `sdlc:test`, `sdlc:verify` | Testing |

## Deployment

### Team/Enterprise Deployment

1. Copy `skills/` directory to shared location
2. Each project runs `/sdlc:init` to configure
3. Projects customize via their preferred config file

### Multi-Tool Teams

For teams using different AI tools:

```bash
# Initialize with all config files
./skills/sdlc-init/scripts/init-sdlc.sh . all

# This creates:
# - CLAUDE.md (for Claude Code users)
# - AGENTS.md (universal format)
# - .cursorrules (for Cursor users)
```

All team members share:
- Same `docs/sdlc/` artifacts
- Same `.sdlc/` templates and standards
- Same pipeline workflow

### Embedded in Project

1. Include `skills/` in project repository
2. Run `/sdlc:init` during project setup
3. Team members share configuration via git
