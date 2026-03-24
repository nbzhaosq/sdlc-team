# SDLC Sub-Agent Team

A complete Software Development Lifecycle (SDLC) pipeline implemented as agent skills with structured handoffs, state management, and multi-AI-tool support.

[中文文档 (Chinese README)](README_CN.md) | [License](LICENSE)

## Installation

### Option 1: One-Line Install (Recommended)

```bash
# Using curl
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# Or using wget
wget -qO- https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# With target directory
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s /path/to/project
```

### Option 2: NPX (Node.js)

```bash
# Initialize in current directory
npx @nbzhaosq/sdlc-team init .

# Specify target directory
npx @nbzhaosq/sdlc-team init /path/to/project

# Create config for specific tool
npx @nbzhaosq/sdlc-team init . --tool cursor

# Create config for all tools
npx @nbzhaosq/sdlc-team init . --all
```

### Option 3: Git Clone

```bash
# Clone the repository
git clone https://github.com/nbzhaosq/sdlc-team.git

# Copy skills to your project
cp -r sdlc-team/skills /path/to/your/project/

# Run initialization
cd /path/to/your/project
./skills/sdlc-init/scripts/init-sdlc.sh .
```

### Option 4: Git Submodule

```bash
# Add as submodule
git submodule add https://github.com/nbzhaosq/sdlc-team.git skills/sdlc-team

# Create symlink to skills (optional)
ln -s sdlc-team/skills skills
```

### Verify Installation

```bash
# Check if skills are installed
ls skills/sdlc*

# Should see:
# skills/sdlc/
# skills/sdlc-init/
# skills/sdlc-requirements/
# skills/sdlc-architecture/
# skills/sdlc-development/
# skills/sdlc-review/
# skills/sdlc-testing/
```

## Features

- **5-Phase Pipeline**: Requirements → Architecture → Development → Review → Testing
- **Structured Handoffs**: Each phase produces artifacts for the next
- **State Management**: Track pipeline progress with `.sdlc-state.json`
- **Multi-Tool Support**: Works with Claude Code, Cursor, Windsurf, and other AI tools
- **Per-Project Customization**: Configure via CLAUDE.md, AGENTS.md, or .cursorrules
- **Quality Gates**: Built-in checklists, linting, and test verification

## Quick Start

### 1. Initialize Project

```bash
# Auto-detect AI tool and configure
/sdlc:init

# Or run the init script
./skills/sdlc-init/scripts/init-sdlc.sh .
```

### 2. Run Pipeline

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

## Commands Reference

| Command | Aliases | Description |
|---------|---------|-------------|
| `/sdlc:init` | `/sdlc-init` | Initialize project for SDLC |
| `/sdlc "feature"` | `/sdlc:run` | Run full 5-phase pipeline |
| `/sdlc --resume <phase>` | | Resume from specific phase |
| `/sdlc --phase <phase>` | | Run single phase only |
| `/sdlc:analyze` | `/sdlc:req` | Phase 1: Requirements Analysis |
| `/sdlc:design` | `/sdlc:arch` | Phase 2: Architecture Design |
| `/sdlc:develop` | `/sdlc:code`, `/sdlc:dev` | Phase 3: Implementation |
| `/sdlc:review` | `/sdlc:code-review` | Phase 4: Code Review |
| `/sdlc:test` | `/sdlc:verify` | Phase 5: Testing & Verification |

## Project Structure

```
your-project/
├── CLAUDE.md                    # Claude Code configuration
├── AGENTS.md                    # Universal AI tool configuration
├── .cursorrules                 # Cursor configuration
├── .sdlc-state.json             # Pipeline state tracking
│
├── docs/
│   └── sdlc/                    # Phase artifacts
│       ├── requirements.md      # Phase 1 output
│       ├── architecture.md      # Phase 2 output
│       ├── implementation-notes.md  # Phase 3 output
│       ├── review-feedback.md   # Phase 4 output
│       └── test-report.md       # Phase 5 output
│
├── .sdlc/
│   ├── templates/               # Custom templates
│   ├── scripts/                 # Custom validation scripts
│   └── standards/               # Coding standards
│
└── skills/                      # SDLC skills (embedded)
    ├── sdlc/                    # Coordinator
    ├── sdlc-init/               # Initialization
    ├── sdlc-requirements/       # Phase 1
    ├── sdlc-architecture/       # Phase 2
    ├── sdlc-development/        # Phase 3
    ├── sdlc-review/             # Phase 4
    └── sdlc-testing/            # Phase 5
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

### Phase Details

| Phase | Input | Output | Checklist |
|-------|-------|--------|-----------|
| 1. Requirements | Feature request | `requirements.md` | User stories, acceptance criteria, edge cases |
| 2. Architecture | `requirements.md` | `architecture.md` | Components, APIs, data models, security |
| 3. Development | `architecture.md` | Code + `implementation-notes.md` | Features, tests, error handling |
| 4. Review | Code + architecture | `review-feedback.md` | Quality, security, performance |
| 5. Testing | Code + review approval | `test-report.md` | Tests pass, criteria verified |

## Multi-Tool Support

### Supported AI Tools

| Tool | Config File | Support Level |
|------|-------------|---------------|
| Claude Code | `CLAUDE.md` | Full (slash commands) |
| Cursor | `.cursorrules` | Workflow guidance |
| Windsurf | `.windsurfrules` | Workflow guidance |
| Generic | `AGENTS.md` | Universal format |

### Initialize for Multiple Tools

```bash
# Create configs for all tools
./skills/sdlc-init/scripts/init-sdlc.sh . all

# Creates:
# - CLAUDE.md (Claude Code)
# - AGENTS.md (Universal)
# - .cursorrules (Cursor)
```

## State Tracking

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
# Start full pipeline
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
# Pipeline interrupted during development
/sdlc --resume development

# Continues from development phase
# Uses existing requirements.md and architecture.md
```

### Example 3: Single Phase Iteration

```bash
# Run only review after manual changes
/sdlc:review

# Or iterate on architecture
/sdlc:design
```

## Deployment

### Team/Enterprise

1. Copy `skills/` to shared location
2. Each project runs `/sdlc:init` to configure
3. Projects customize via their config file(s)
4. Team shares templates and standards

### Embedded in Project

1. Include `skills/` in project repository
2. Run `/sdlc:init` during project setup
3. Commit `.sdlc-state.json` and config files
4. Team members share configuration via git

## Skills Reference

| Skill | Name | Aliases | Purpose |
|-------|------|---------|---------|
| Coordinator | `sdlc` | `sdlc:run`, `sdlc:pipeline` | Main orchestrator |
| Init | `sdlc:init` | `sdlc-init` | Project initialization |
| Phase 1 | `sdlc:requirements` | `sdlc:analyze`, `sdlc:req` | Requirements Analysis |
| Phase 2 | `sdlc:architecture` | `sdlc:design`, `sdlc:arch` | Architecture Design |
| Phase 3 | `sdlc:development` | `sdlc:develop`, `sdlc:code` | Implementation |
| Phase 4 | `sdlc:review` | `sdlc:code-review` | Code Review |
| Phase 5 | `sdlc:testing` | `sdlc:test`, `sdlc:verify` | Testing & Verification |

## Requirements

- Claude Code (for slash commands) or compatible AI tool
- Bash (for scripts)
- Project-appropriate tools (npm, pytest, go test, etc.)

## License

MIT
