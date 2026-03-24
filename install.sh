#!/bin/bash
# SDLC Sub-Agent Team - Universal Installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s /path/to/project
#   curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool claude-code

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/nbzhaosq/sdlc-team.git"
BRANCH="${SDLC_BRANCH:-main}"
TARGET_DIR="${1:-.}"
TOOL="${2:-}"
ALL_TOOLS=false

# Parse arguments
shift 2>/dev/null || true
while [[ $# -gt 0 ]]; do
  case $1 in
    --tool|-t)
      TOOL="$2"
      shift 2
      ;;
    --all|-a)
      ALL_TOOLS=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         SDLC Sub-Agent Team Installer                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Supported tools
declare -A TOOLS
TOOLS["claude-code"]="Claude Code|.claude/skills|CLAUDE.md"
TOOLS["opencode"]="OpenCode|.opencode/skills|OPENCODE.md"
TOOLS["qodercli"]="QoderCLI|.qoder/skills|QODER.md"
TOOLS["cursor"]="Cursor|.cursor/skills|.cursorrules"
TOOLS["generic"]="Generic|skills|AGENTS.md"

# Function to prompt for tool selection
prompt_tool() {
  echo -e "${CYAN}${BOLD}Select your AI tool:${NC}"
  echo ""

  local i=1
  for tool in "${!TOOLS[@]}"; do
    IFS='|' read -r name skills_dir config <<< "${TOOLS[$tool]}"
    echo -e "  ${CYAN}${i}.${NC} ${BOLD}${name}${NC}"
    echo "     Skills dir: ${skills_dir}"
    echo "     Config: ${config_file}"
    echo ""
    ((i++))
  done

  echo -e "  ${CYAN}a.${NC} ${BOLD}All tools${NC} (install for all)"
  echo ""

  read -p "Enter choice [1-${#TOOLS[@]}/a]: " choice

  case $choice in
    a|A|all)
      echo "all"
      ;;
    *)
      local keys=("${!TOOLS[@]}")
      local idx=$((choice - 1))
      if [[ $idx -ge 0 && $idx -lt ${#TOOLS[@]} ]]; then
        echo "${keys[$idx]}"
      else
        echo "claude-code"
      fi
      ;;
  esac
}

# Function to install for a specific tool
install_for_tool() {
  local tool_key=$1
  local target=$2

  IFS='|' read -r name skills_dir config_file <<< "${TOOLS[$tool_key]}"

  echo -e "${CYAN}"
  echo -e "${BOLD}Installing for ${name}:${NC}"
  echo -e "${BLUE}  Skills directory: ${skills_dir}${NC}"

  # Create skills directory
  mkdir -p "${target}/${skills_dir}"

  # Copy skills from temp clone
  if [ -d "/tmp/sdlc-team/skills" ]; then
    cp -r /tmp/sdlc-team/skills/* "${target}/${skills_dir}/"
    echo -e "${GREEN}  ✓ Copied SDLC skills${NC}"
  fi

  # Create docs/sdlc directory
  mkdir -p "${target}/docs/sdlc"
  echo -e "${GREEN}  ✓ Created docs/sdlc/${NC}"

  # Create .sdlc directory
  mkdir -p "${target}/.sdlc/templates"
  mkdir -p "${target}/.sdlc/scripts"
  echo -e "${GREEN}  ✓ Created .sdlc/${NC}"

  # Create state file
  if [ ! -f "${target}/.sdlc-state.json" ]; then
    cat > "${target}/.sdlc-state.json" << 'EOF'
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
    echo -e "${GREEN}  ✓ Created .sdlc-state.json${NC}"
  else
    echo -e "${YELLOW}  ⚠ .sdlc-state.json exists, skipping${NC}"
  fi

  # Create config file
  create_config_file "$tool_key" "$target" "$config_file"
}

# Function to create config file
create_config_file() {
  local tool_key=$1
  local target=$2
  local config_file=$3
  local config_path="${target}/${config_file}"

  if [ -f "$config_path" ]; then
    echo -e "${YELLOW}  ⚠ ${config_file} exists, skipping${NC}"
    return
  fi

  case "$config_file" in
    "CLAUDE.md"|"OPENCODE.md"|"QODER.md")
      cat > "$config_path" << 'EOF'
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
      ;;
    ".cursorrules")
      cat > "$config_path" << 'EOF'
# SDLC Configuration

Use the SDLC pipeline for structured development.

## Workflow

1. Requirements → docs/sdlc/requirements.md
2. Architecture → docs/sdlc/architecture.md
3. Development → Implement per architecture
4. Review → Quality and security checks
5. Testing → docs/sdlc/test-report.md

## Quality Requirements

- Test coverage: 80% minimum
- Run linters before commit
- Review security implications

## Tech Stack

[Define your tech stack here]
EOF
      ;;
    "AGENTS.md")
      cat > "$config_path" << 'EOF'
# Project Configuration

This file configures AI assistants for this project.

## SDLC Pipeline

This project uses the SDLC pipeline for structured development.

### Workflow

1. **Requirements** - Document in `docs/sdlc/requirements.md`
2. **Architecture** - Design in `docs/sdlc/architecture.md`
3. **Development** - Implement per architecture
4. **Review** - Quality and security checks
5. **Testing** - Verify in `docs/sdlc/test-report.md`

### Quality Gates

- Test coverage minimum: 80%
- Run linters before completion
- Review for security implications

## Project Info

- **Tech Stack**: [Define here]
EOF
      ;;
  esac

  echo -e "${GREEN}  ✓ Created ${config_file}${NC}"
}

# Resolve target path
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")
echo -e "${BLUE}Target: ${TARGET_DIR}${NC}"

# Clone repository
echo -e "${BLUE}Downloading SDLC Team...${NC}"
rm -rf /tmp/sdlc-team
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" /tmp/sdlc-team 2>/dev/null

# Determine which tool(s) to install
if [ "$ALL_TOOLS" = true ]; then
  TOOLS_TO_INSTALL=("${!TOOLS[@]}")
elif [ -n "$TOOL" ] && [ -n "${TOOLS[$TOOL]}" ]; then
  TOOLS_TO_INSTALL=("$TOOL")
else
  # Interactive selection
  SELECTED=$(prompt_tool)
  if [ "$SELECTED" = "all" ]; then
    TOOLS_TO_INSTALL=("${!TOOLS[@]}")
  else
    TOOLS_TO_INSTALL=("$SELECTED")
  fi
fi

# Install for each tool
for tool_key in "${TOOLS_TO_INSTALL[@]}"; do
  install_for_tool "$tool_key" "$TARGET_DIR"
done

# Clean up
rm -rf /tmp/sdlc-team

# Summary
echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  ✓ Installation Complete                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}Installed for:${NC}"
for tool_key in "${TOOLS_TO_INSTALL[@]}"; do
  IFS='|' read -r name skills_dir _ <<< "${TOOLS[$tool_key]}"
  echo "  • ${name} (${skills_dir})"
done

echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "${YELLOW}  1. Edit config file to customize SDLC settings${NC}"
echo -e "${YELLOW}  2. Start with: /sdlc:analyze \"Your feature\"${NC}"

echo ""
echo -e "${CYAN}Commands:${NC}"
echo "  /sdlc \"feature\"    - Run full pipeline"
echo "  /sdlc:analyze      - Phase 1: Requirements"
echo "  /sdlc:design       - Phase 2: Architecture"
echo "  /sdlc:develop      - Phase 3: Development"
echo "  /sdlc:review       - Phase 4: Code Review"
echo "  /sdlc:test         - Phase 5: Testing"
