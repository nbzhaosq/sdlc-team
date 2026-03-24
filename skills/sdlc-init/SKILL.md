---
name: sdlc:init
aliases: ["sdlc-init"]
description: Initialize SDLC configuration for a new or existing project (supports multiple AI tools)
user_invocable: true
---

# SDLC Project Initialization

Initialize the SDLC pipeline configuration for your project. Supports multiple AI programming tools with automatic detection and configuration.

## Usage

```
/sdlc:init
```

## Supported AI Tools

| Tool | Config File | Notes |
|------|-------------|-------|
| Claude Code | `CLAUDE.md` | Primary support |
| Cursor | `.cursorrules` | Via AGENTS.md pattern |
| Windsurf | `.windsurfrules` | Via AGENTS.md pattern |
| Generic | `AGENTS.md` | Universal format |
| Aider | `.aider.conf.yml` | Limited support |

## What It Does

1. Detects existing AI tool configuration
2. Creates `docs/sdlc/` directory for artifacts
3. Creates `.sdlc-state.json` initial state file
4. Adds SDLC configuration to appropriate config file(s)
5. Sets up custom templates directory (optional)

## Initialization Checklist

- [ ] Detect AI tool configuration files
- [ ] Create `docs/sdlc/` directory
- [ ] Create initial `.sdlc-state.json`
- [ ] Configure SDLC settings in config file(s)
- [ ] Set up custom templates (optional)
- [ ] Verify skill availability

## Process

### Step 1: Detect Configuration Files

The initialization will check for these files in order:

```
CLAUDE.md          # Claude Code (primary)
AGENTS.md          # Generic/Universal
.cursorrules       # Cursor
.windsurfrules     # Windsurf
.aider.conf.yml    # Aider
```

### Step 2: Create Directory Structure

```bash
mkdir -p docs/sdlc
mkdir -p .sdlc/templates
mkdir -p .sdlc/scripts
mkdir -p .sdlc/standards
```

### Step 3: Create Initial State File

Create `.sdlc-state.json`:

```json
{
  "project": "",
  "current_phase": null,
  "phases": {
    "requirements": { "status": "pending" },
    "architecture": { "status": "pending" },
    "development": { "status": "pending" },
    "review": { "status": "pending" },
    "testing": { "status": "pending" }
  },
  "artifacts": {},
  "created_at": null,
  "updated_at": null
}
```

### Step 4: Generate Configuration

#### For CLAUDE.md (Claude Code)

```markdown
# SDLC Configuration

This project uses the SDLC pipeline for structured development.

## Project Info

- **Name**: [Project Name]
- **Tech Stack**: [e.g., TypeScript, React, Node.js, PostgreSQL]

## Quick Commands

| Command | Description |
|---------|-------------|
| `/sdlc "feature"` | Run full pipeline |
| `/sdlc:analyze "feature"` | Requirements only |
| `/sdlc:design` | Architecture only |
| `/sdlc:develop` | Implementation only |
| `/sdlc:review` | Code review only |
| `/sdlc:test` | Testing only |

## Phase Customizations

### Requirements Phase
- Template: default

### Architecture Phase
- Template: default

### Development Phase
- Test coverage minimum: 80%

### Review Phase
- Run: `npm run lint && npm run typecheck`

### Testing Phase
- Commands: `npm test`
- Coverage threshold: 80%
```

#### For AGENTS.md (Universal)

```markdown
# Project Agents Configuration

This file configures AI assistants for this project.

## SDLC Pipeline

This project uses the SDLC (Software Development Lifecycle) pipeline for structured development.

### Available Phases

1. **Requirements** - Analyze and document feature requirements
2. **Architecture** - Design system architecture and APIs
3. **Development** - Implement features following architecture
4. **Review** - Code review and quality checks
5. **Testing** - Verify acceptance criteria and run tests

### Workflow

When implementing new features:
1. Start with requirements analysis
2. Design architecture before coding
3. Implement following the design
4. Review code quality and security
5. Test and verify acceptance criteria

### Configuration

- Requirements output: `docs/sdlc/requirements.md`
- Architecture output: `docs/sdlc/architecture.md`
- Implementation notes: `docs/sdlc/implementation-notes.md`
- Review feedback: `docs/sdlc/review-feedback.md`
- Test report: `docs/sdlc/test-report.md`

### Quality Gates

- Test coverage minimum: 80%
- Required checks: linting, type checking
- Security: OWASP Top 10 review

## Project Info

- **Tech Stack**: [e.g., TypeScript, React, Node.js]
- **Testing**: [e.g., Jest, Playwright]
- **CI/CD**: [e.g., GitHub Actions]

## Coding Standards

- Follow existing code patterns
- Write tests for new code
- Document complex logic
- Handle error cases
```

#### For .cursorrules (Cursor)

```markdown
# SDLC Configuration

Use the SDLC pipeline for structured development:

## Workflow

1. **Requirements**: Document in `docs/sdlc/requirements.md`
2. **Architecture**: Design in `docs/sdlc/architecture.md`
3. **Development**: Implement per architecture
4. **Review**: Check code quality and security
5. **Testing**: Verify in `docs/sdlc/test-report.md`

## Commands (if using Claude Code integration)

- `/sdlc:analyze "feature"` - Requirements
- `/sdlc:design` - Architecture
- `/sdlc:develop` - Implementation
- `/sdlc:review` - Code review
- `/sdlc:test` - Testing

## Quality Requirements

- Test coverage: 80% minimum
- Run linters before commit
- Review security implications

## Tech Stack

[Define your tech stack here]
```

## Multi-Tool Projects

For projects using multiple AI tools, the initialization can create configurations for all of them:

```bash
# Create for all detected tools
/sdlc:init --all

# Create for specific tool
/sdlc:init --tool claude
/sdlc:init --tool cursor
/sdlc:init --tool agents
```

## Verification

After initialization, verify setup:

1. Check directory structure:
   ```bash
   ls -la docs/sdlc/
   ls -la .sdlc/
   cat .sdlc-state.json
   ```

2. Verify config file contains SDLC section

3. Test the pipeline with your AI tool

## Configuration File Priority

When multiple config files exist, the SDLC will read from them in this priority:

1. `CLAUDE.md` (Claude Code)
2. `AGENTS.md` (Universal)
3. `.cursorrules` (Cursor)
4. Tool-specific rules files

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Config file not detected | Manually specify with `--tool` |
| Multiple configs conflict | Use `--tool` to specify which to update |
| Skills not found | Ensure skills are in `skills/` directory |
| Phase fails | Check prior phase artifacts exist |
