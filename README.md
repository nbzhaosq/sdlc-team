# SDLC Sub-Agent Team

A complete Software Development Lifecycle (SDLC) pipeline implemented as agent skills with structured handoffs, state management, and multi-AI-tool support.

## Installation

### Option 1: One-Line Install (Recommended)

```bash
# Interactive selection
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# Specify tool
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool claude-code
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool opencode
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool qodercli
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool cursor

# Install for all tools
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --all
```

### Option 2: NPX

```bash
# Interactive selection
npx @nbzhaosq/sdlc-team init .

# Specify tool
npx @nbzhaosq/sdlc-team init . --tool claude-code
npx @nbzhaosq/sdlc-team init . --tool opencode
npx @nbzhaosq/sdlc-team init . --tool qodercli

# Install for all tools
npx @nbzhaosq/sdlc-team init . --all
```

### Option 3: Git Clone

```bash
git clone https://github.com/nbzhaosq/sdlc-team.git
cp -r sdlc-team/skills /path/to/your/project/.claude/
# or: cp -r sdlc-team/skills /path/to/your/project/.opencode/
# or: cp -r sdlc-team/skills /path/to/your/project/.qoder/
```

## Supported AI Tools

| Tool | Skills Directory | Config File | Command Prefix |
|------|-----------------|-------------|----------------|
| Claude Code | `.claude/skills/` | `CLAUDE.md` | `/sdlc:*` |
| OpenCode | `.opencode/skills/` | `OPENCODE.md` | `/sdlc:*` |
| QoderCLI | `.qoder/skills/` | `QODER.md` | `/sdlc:*` |
| Cursor | `.cursor/skills/` | `.cursorrules` | `Cmd+K` |
| Generic | `skills/` | `AGENTS.md` | workflow |

## Features

- **5-Phase Pipeline**: Requirements → Architecture → Development → Review → Testing
- **Structured Handoffs**: Each phase produces artifacts for the next
- **State Management**: Track pipeline progress with `.sdlc-state.json`
- **Multi-Tool Support**: Works with Claude Code, OpenCode, QoderCLI, Cursor, and generic AI tools
- **Per-Project Customization**: Configure via tool-specific config files
- **Quality Gates**: Built-in checklists, linting, and test verification

## Quick Start

### 1. Install

```bash
# Interactive - will prompt for tool selection
npx @nbzhaosq/sdlc-team init .

# Or specify your tool
npx @nbzhaosq/sdlc-team init . --tool claude-code
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
| `/sdlc "feature"` | `/sdlc:run` | Run full 5-phase pipeline |
| `/sdlc --resume <phase>` | | Resume from specific phase |
| `/sdlc:analyze` | `/sdlc:req` | Phase 1: Requirements Analysis |
| `/sdlc:design` | `/sdlc:arch` | Phase 2: Architecture Design |
| `/sdlc:develop` | `/sdlc:code` | Phase 3: Implementation |
| `/sdlc:review` | `/sdlc:code-review` | Phase 4: Code Review |
| `/sdlc:test` | `/sdlc:verify` | Phase 5: Testing & Verification |

## Project Structure

```
your-project/
├── .claude/skills/          # Claude Code skills (or .opencode/skills, .qoder/skills)
│   ├── sdlc/                # Coordinator
│   ├── sdlc-requirements/   # Phase 1
│   ├── sdlc-architecture/   # Phase 2
│   ├── sdlc-development/    # Phase 3
│   ├── sdlc-review/         # Phase 4
│   └── sdlc-testing/        # Phase 5
│
├── CLAUDE.md               # Tool config (or OPENCODE.md, QODER.md, etc.)
├── .sdlc-state.json        # Pipeline state tracking
│
├── docs/
│   └── sdlc/               # Phase artifacts
│       ├── requirements.md
│       ├── architecture.md
│       ├── implementation-notes.md
│       ├── review-feedback.md
│       └── test-report.md
│
└── .sdlc/                  # Customizations
    ├── templates/
    ├── scripts/
    └── standards/
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

## Skills Reference

| Skill | Name | Aliases | Purpose |
|-------|------|---------|---------|
| Coordinator | `sdlc` | `sdlc:run` | Main orchestrator |
| Phase 1 | `sdlc:requirements` | `sdlc:analyze`, `sdlc:req` | Requirements Analysis |
| Phase 2 | `sdlc:architecture` | `sdlc:design`, `sdlc:arch` | Architecture Design |
| Phase 3 | `sdlc:development` | `sdlc:develop`, `sdlc:code` | Implementation |
| Phase 4 | `sdlc:review` | `sdlc:code-review` | Code Review |
| Phase 5 | `sdlc:testing` | `sdlc:test`, `sdlc:verify` | Testing & Verification |

## Requirements

- Node.js >= 18.0.0 (for NPX)
- Bash (for shell scripts)
- Git (for cloning)
- Project-appropriate tools (npm, pytest, go test, etc.)

## License

MIT
