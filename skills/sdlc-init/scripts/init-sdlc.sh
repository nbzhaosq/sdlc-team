#!/bin/bash
# SDLC Project Initialization Script
# Sets up the required directory structure and configuration for SDLC pipeline
# Supports multiple AI programming tools

set -e

PROJECT_ROOT="${1:-.}"
TOOL="${2:-auto}"  # auto, claude, cursor, windsurf, agents, all

cd "$PROJECT_ROOT"

echo "=== SDLC Project Initialization ==="
echo "Project root: $(pwd)"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Step 1: Detect existing AI tool configurations
echo -e "${BLUE}Step 1: Detecting AI tool configurations...${NC}"

CONFIG_FILES=(
    "CLAUDE.md"
    "AGENTS.md"
    ".cursorrules"
    ".windsurfrules"
    ".aider.conf.yml"
)

DETECTED_TOOLS=()
for config in "${CONFIG_FILES[@]}"; do
    if [ -f "$config" ]; then
        DETECTED_TOOLS+=("$config")
        echo -e "${GREEN}✓ Found: $config${NC}"
    fi
done

if [ ${#DETECTED_TOOLS[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠ No AI tool configuration detected${NC}"
fi
echo ""

# Determine which tool(s) to configure
CONFIGURE_TOOLS=()
if [ "$TOOL" = "auto" ]; then
    if [ ${#DETECTED_TOOLS[@]} -gt 0 ]; then
        # Configure the first detected tool
        CONFIGURE_TOOLS=("${DETECTED_TOOLS[0]}")
        echo -e "${BLUE}Auto-detected, will configure: ${CONFIGURE_TOOLS[0]}${NC}"
    else
        # Default to CLAUDE.md for Claude Code
        CONFIGURE_TOOLS=("CLAUDE.md")
        echo -e "${BLUE}No config detected, defaulting to: CLAUDE.md${NC}"
    fi
elif [ "$TOOL" = "all" ]; then
    # Configure all common config files
    CONFIGURE_TOOLS=("CLAUDE.md" "AGENTS.md" ".cursorrules")
    echo -e "${BLUE}Will configure all: ${CONFIGURE_TOOLS[*]}${NC}"
elif [ "$TOOL" = "claude" ]; then
    CONFIGURE_TOOLS=("CLAUDE.md")
elif [ "$TOOL" = "cursor" ]; then
    CONFIGURE_TOOLS=(".cursorrules")
elif [ "$TOOL" = "windsurf" ]; then
    CONFIGURE_TOOLS=(".windsurfrules")
elif [ "$TOOL" = "agents" ]; then
    CONFIGURE_TOOLS=("AGENTS.md")
else
    CONFIGURE_TOOLS=("CLAUDE.md")
fi
echo ""

# Step 2: Create directory structure
echo -e "${BLUE}Step 2: Creating directory structure...${NC}"

mkdir -p docs/sdlc
mkdir -p .sdlc/templates
mkdir -p .sdlc/scripts
mkdir -p .sdlc/standards

echo -e "${GREEN}✓ Created docs/sdlc/${NC}"
echo -e "${GREEN}✓ Created .sdlc/templates/${NC}"
echo -e "${GREEN}✓ Created .sdlc/scripts/${NC}"
echo -e "${GREEN}✓ Created .sdlc/standards/${NC}"
echo ""

# Step 3: Create initial state file
echo -e "${BLUE}Step 3: Creating initial state file...${NC}"

STATE_FILE=".sdlc-state.json"

if [ -f "$STATE_FILE" ]; then
    echo -e "${YELLOW}⚠ $STATE_FILE already exists, skipping${NC}"
else
    cat > "$STATE_FILE" << 'EOF'
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
EOF
    echo -e "${GREEN}✓ Created $STATE_FILE${NC}"
fi
echo ""

# Step 4: Generate configuration for each tool
echo -e "${BLUE}Step 4: Generating configuration files...${NC}"

# Function to generate CLAUDE.md content
generate_claude_md() {
    local file="$1"
    local append_mode="$2"

    if [ "$append_mode" = "true" ] && [ -f "$file" ]; then
        cat >> "$file" << 'EOF'

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
EOF
    else
        cat > "$file" << 'EOF'
# Project Configuration

## Overview

[Project description]

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
EOF
    fi
}

# Function to generate AGENTS.md content
generate_agents_md() {
    local file="$1"
    local append_mode="$2"

    if [ "$append_mode" = "true" ] && [ -f "$file" ]; then
        cat >> "$file" << 'EOF'

# SDLC Pipeline Configuration

This project uses the SDLC pipeline for structured development.

## Workflow

When implementing new features, follow this workflow:

1. **Requirements Analysis** - Document requirements in `docs/sdlc/requirements.md`
2. **Architecture Design** - Create design in `docs/sdlc/architecture.md`
3. **Development** - Implement features following the architecture
4. **Code Review** - Review for quality, security, and performance
5. **Testing** - Verify acceptance criteria, document in `docs/sdlc/test-report.md`

## Quality Gates

- Test coverage minimum: 80%
- Run linters before considering work complete
- Review for security implications (OWASP Top 10)
- Document complex logic

## Output Artifacts

| Phase | Output File |
|-------|-------------|
| Requirements | `docs/sdlc/requirements.md` |
| Architecture | `docs/sdlc/architecture.md` |
| Development | `docs/sdlc/implementation-notes.md` |
| Review | `docs/sdlc/review-feedback.md` |
| Testing | `docs/sdlc/test-report.md` |
EOF
    else
        cat > "$file" << 'EOF'
# Project Agents Configuration

This file configures AI assistants for this project.

## Project Overview

[Describe your project here]

## Tech Stack

- Frontend: [e.g., React, TypeScript]
- Backend: [e.g., Node.js, Express]
- Database: [e.g., PostgreSQL]
- Testing: [e.g., Jest, Playwright]

# SDLC Pipeline Configuration

This project uses the SDLC pipeline for structured development.

## Workflow

When implementing new features, follow this workflow:

1. **Requirements Analysis** - Document requirements in `docs/sdlc/requirements.md`
2. **Architecture Design** - Create design in `docs/sdlc/architecture.md`
3. **Development** - Implement features following the architecture
4. **Code Review** - Review for quality, security, and performance
5. **Testing** - Verify acceptance criteria, document in `docs/sdlc/test-report.md`

## Quality Gates

- Test coverage minimum: 80%
- Run linters before considering work complete
- Review for security implications (OWASP Top 10)
- Document complex logic

## Output Artifacts

| Phase | Output File |
|-------|-------------|
| Requirements | `docs/sdlc/requirements.md` |
| Architecture | `docs/sdlc/architecture.md` |
| Development | `docs/sdlc/implementation-notes.md` |
| Review | `docs/sdlc/review-feedback.md` |
| Testing | `docs/sdlc/test-report.md` |

## Coding Standards

- Follow existing code patterns
- Write tests for new code
- Document complex logic
- Handle error cases appropriately
- Use meaningful variable and function names
EOF
    fi
}

# Function to generate .cursorrules content
generate_cursorrules() {
    local file="$1"
    local append_mode="$2"

    if [ "$append_mode" = "true" ] && [ -f "$file" ]; then
        cat >> "$file" << 'EOF'

# SDLC Pipeline

Use the SDLC pipeline for structured development.

## Workflow

1. Requirements → `docs/sdlc/requirements.md`
2. Architecture → `docs/sdlc/architecture.md`
3. Development → Implement per architecture
4. Review → Quality and security checks
5. Testing → `docs/sdlc/test-report.md`

## Quality Requirements

- Test coverage: 80% minimum
- Run linters before completion
- Review security implications
- Document complex logic

## Configuration

- Requirements template: `.sdlc/templates/requirements-template.md`
- Architecture template: `.sdlc/templates/architecture-template.md`
- Coding standards: `.sdlc/standards/coding-standards.md`
EOF
    else
        cat > "$file" << 'EOF'
# Project Rules for Cursor

## Tech Stack

[Define your tech stack here]

## Coding Guidelines

- Follow existing patterns
- Write clean, readable code
- Add comments for complex logic
- Write tests for new functionality

# SDLC Pipeline

Use the SDLC pipeline for structured development.

## Workflow

1. Requirements → `docs/sdlc/requirements.md`
2. Architecture → `docs/sdlc/architecture.md`
3. Development → Implement per architecture
4. Review → Quality and security checks
5. Testing → `docs/sdlc/test-report.md`

## Quality Requirements

- Test coverage: 80% minimum
- Run linters before completion
- Review security implications
- Document complex logic

## Configuration

- Requirements template: `.sdlc/templates/requirements-template.md`
- Architecture template: `.sdlc/templates/architecture-template.md`
- Coding standards: `.sdlc/standards/coding-standards.md`
EOF
    fi
}

# Generate configuration for each tool
for tool_config in "${CONFIGURE_TOOLS[@]}"; do
    SDLC_MARKER="# SDLC"

    if [ -f "$tool_config" ]; then
        if grep -q "$SDLC_MARKER" "$tool_config" 2>/dev/null; then
            echo -e "${YELLOW}⚠ $tool_config already contains SDLC configuration, skipping${NC}"
        else
            case "$tool_config" in
                "CLAUDE.md")
                    generate_claude_md "$tool_config" "true"
                    ;;
                "AGENTS.md")
                    generate_agents_md "$tool_config" "true"
                    ;;
                ".cursorrules")
                    generate_cursorrules "$tool_config" "true"
                    ;;
                *)
                    echo -e "${YELLOW}⚠ Unknown config type: $tool_config${NC}"
                    ;;
            esac
            echo -e "${GREEN}✓ Updated $tool_config with SDLC configuration${NC}"
        fi
    else
        case "$tool_config" in
            "CLAUDE.md")
                generate_claude_md "$tool_config" "false"
                ;;
            "AGENTS.md")
                generate_agents_md "$tool_config" "false"
                ;;
            ".cursorrules")
                generate_cursorrules "$tool_config" "false"
                ;;
            *)
                echo -e "${YELLOW}⚠ Unknown config type: $tool_config${NC}"
                ;;
        esac
        echo -e "${GREEN}✓ Created $tool_config with SDLC configuration${NC}"
    fi
done
echo ""

# Step 5: Detect project type and configure
echo -e "${BLUE}Step 5: Detecting project type...${NC}"

PROJECT_TYPE="unknown"
TEST_CMD=""
LINT_CMD=""

if [ -f "package.json" ]; then
    PROJECT_TYPE="javascript/typescript"

    if grep -q '"test"' package.json 2>/dev/null; then
        TEST_CMD="npm test"
    fi

    if grep -q '"lint"' package.json 2>/dev/null; then
        LINT_CMD="npm run lint"
    fi

    echo -e "${GREEN}✓ Detected: $PROJECT_TYPE${NC}"

elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
    TEST_CMD="pytest"
    LINT_CMD="flake8"
    echo -e "${GREEN}✓ Detected: $PROJECT_TYPE${NC}"

elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
    TEST_CMD="go test ./..."
    LINT_CMD="go vet ./..."
    echo -e "${GREEN}✓ Detected: $PROJECT_TYPE${NC}"

elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
    TEST_CMD="cargo test"
    LINT_CMD="cargo clippy"
    echo -e "${GREEN}✓ Detected: $PROJECT_TYPE${NC}"
else
    echo -e "${YELLOW}⚠ Could not detect project type${NC}"
fi

if [ -n "$TEST_CMD" ] || [ -n "$LINT_CMD" ]; then
    echo ""
    echo -e "${BLUE}Suggested additions to config:${NC}"
    [ -n "$TEST_CMD" ] && echo "  Testing Commands: \`$TEST_CMD\`"
    [ -n "$LINT_CMD" ] && echo "  Lint Commands: \`$LINT_CMD\`"
fi
echo ""

# Step 6: Copy templates (optional)
echo -e "${BLUE}Step 6: Template setup (optional)...${NC}"

SKILLS_DIR="${SKILLS_DIR:-skills}"

if [ -d "$SKILLS_DIR/sdlc-requirements/references" ]; then
    read -p "Copy default templates for customization? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$SKILLS_DIR/sdlc-requirements/references/requirements-template.md" ".sdlc/templates/" 2>/dev/null || true
        cp "$SKILLS_DIR/sdlc-architecture/references/architecture-template.md" ".sdlc/templates/" 2>/dev/null || true
        cp "$SKILLS_DIR/sdlc-development/references/coding-standards.md" ".sdlc/standards/" 2>/dev/null || true
        echo -e "${GREEN}✓ Copied templates to .sdlc/${NC}"
    else
        echo -e "${YELLOW}⊘ Skipped template copy${NC}"
    fi
else
    echo -e "${YELLOW}⊘ Skills directory not found, skipping template copy${NC}"
fi
echo ""

# Summary
echo "=== Initialization Complete ==="
echo ""
echo -e "${CYAN}Created structure:${NC}"
echo "  docs/sdlc/          - SDLC artifacts"
echo "  .sdlc/templates/    - Custom templates"
echo "  .sdlc/scripts/      - Custom scripts"
echo "  .sdlc/standards/    - Coding standards"
echo "  .sdlc-state.json    - Pipeline state"
echo ""
echo -e "${CYAN}Configuration files:${NC}"
for tool_config in "${CONFIGURE_TOOLS[@]}"; do
    if [ -f "$tool_config" ]; then
        echo "  $tool_config"
    fi
done
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Edit config file(s) to customize SDLC settings"
echo "  2. Update project name and tech stack"
echo "  3. Start with requirements: analyze your first feature"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  Claude Code:  /sdlc:analyze \"Your feature description\""
echo "  Other tools:  Follow workflow in config file"
echo ""
