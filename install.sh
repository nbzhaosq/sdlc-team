#!/bin/bash
# SDLC Sub-Agent Team - Universal Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/your-org/sdlc-team/main/install.sh | bash
# Or:    ./install.sh [target-dir]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPO_URL="${SDLC_REPO_URL:-https://github.com/nbzhaosq/sdlc-team.git}"
BRANCH="${SDLC_BRANCH:-main}"
TARGET_DIR="${1:-.}"
SKILLS_DIR="skills"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          SDLC Sub-Agent Team Installer                     ║"
echo "║          软件开发生命周期技能团队安装器                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Detect installation method
echo -e "${BLUE}[1/5] Detecting installation method...${NC}"

INSTALL_METHOD="unknown"
if [ -d ".git" ]; then
    INSTALL_METHOD="existing-project"
    echo -e "${GREEN}✓ Detected existing git project${NC}"
elif [ -f "package.json" ] || [ -f "pyproject.toml" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ]; then
    INSTALL_METHOD="existing-project"
    echo -e "${GREEN}✓ Detected existing project${NC}"
else
    INSTALL_METHOD="new-project"
    echo -e "${YELLOW}→ New or empty directory${NC}"
fi

# Step 2: Download or copy skills
echo ""
echo -e "${BLUE}[2/5] Installing SDLC skills...${NC}"

# Check if skills already exist
if [ -d "$SKILLS_DIR/sdlc" ]; then
    echo -e "${YELLOW}⚠ SDLC skills already installed in $SKILLS_DIR/${NC}"
    read -p "Reinstall? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}→ Skipping skills installation${NC}"
    else
        rm -rf "$SKILLS_DIR/sdlc"*
    fi
fi

# Install skills
if [ ! -d "$SKILLS_DIR/sdlc" ]; then
    # Check if we're running from the repo itself
    if [ -f "$(dirname "$0")/skills/sdlc/SKILL.md" ]; then
        echo -e "${GREEN}✓ Copying from local source${NC}"
        mkdir -p "$SKILLS_DIR"
        cp -r "$(dirname "$0")/skills/"* "$SKILLS_DIR/"
    elif command -v git &> /dev/null; then
        echo -e "${GREEN}✓ Cloning from repository...${NC}"
        TEMP_DIR=$(mktemp -d)
        git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
            echo -e "${RED}✗ Failed to clone repository${NC}"
            echo -e "${YELLOW}  Try setting SDLC_REPO_URL environment variable${NC}"
            exit 1
        }
        mkdir -p "$SKILLS_DIR"
        cp -r "$TEMP_DIR/skills/"* "$SKILLS_DIR/"
        rm -rf "$TEMP_DIR"
    else
        echo -e "${RED}✗ Git not found. Please install git or download manually.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Skills installed to $SKILLS_DIR/${NC}"

# Step 3: Run initialization
echo ""
echo -e "${BLUE}[3/5] Initializing SDLC configuration...${NC}"

# Run the init script
if [ -f "$SKILLS_DIR/sdlc-init/scripts/init-sdlc.sh" ]; then
    chmod +x "$SKILLS_DIR/sdlc-init/scripts/init-sdlc.sh"
    bash "$SKILLS_DIR/sdlc-init/scripts/init-sdlc.sh" "." "auto" << 'INIT_INPUT'
n
INIT_INPUT
else
    echo -e "${YELLOW}⚠ Init script not found, creating basic structure${NC}"
    mkdir -p docs/sdlc
    mkdir -p .sdlc/templates
    mkdir -p .sdlc/scripts
    mkdir -p .sdlc/standards

    # Create state file
    cat > .sdlc-state.json << 'EOF'
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

    # Create CLAUDE.md if not exists
    if [ ! -f "CLAUDE.md" ]; then
        cat > CLAUDE.md << 'EOF'
# Project Configuration

## Overview

[Project description]

# SDLC Configuration

This project uses the SDLC pipeline for structured development.

## Quick Commands

| Command | Description |
|---------|-------------|
| `/sdlc "feature"` | Run full pipeline |
| `/sdlc:analyze "feature"` | Requirements only |
| `/sdlc:design` | Architecture only |
| `/sdlc:develop` | Implementation only |
| `/sdlc:review` | Code review only |
| `/sdlc:test` | Testing only |
EOF
    fi
fi

# Step 4: Set permissions
echo ""
echo -e "${BLUE}[4/5] Setting permissions...${NC}"

find "$SKILLS_DIR" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
echo -e "${GREEN}✓ Scripts are executable${NC}"

# Step 5: Show completion message
echo ""
echo -e "${BLUE}[5/5] Installation complete!${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  ✓ Installation Successful                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Installed:${NC}"
echo "  • skills/sdlc*/          - SDLC phase skills"
echo "  • docs/sdlc/             - Artifact directory"
echo "  • .sdlc/                 - Customization directory"
echo "  • .sdlc-state.json       - Pipeline state"
echo "  • CLAUDE.md (or AGENTS.md) - Configuration"
echo ""
echo -e "${CYAN}Quick Start:${NC}"
echo ""
echo -e "  ${YELLOW}For Claude Code:${NC}"
echo "    /sdlc:analyze \"Your feature description\""
echo ""
echo -e "  ${YELLOW}For other AI tools:${NC}"
echo "    Follow the SDLC workflow in your config file"
echo ""
echo -e "${CYAN}Available Commands:${NC}"
echo "  /sdlc:init      - Reinitialize configuration"
echo "  /sdlc:analyze   - Phase 1: Requirements"
echo "  /sdlc:design    - Phase 2: Architecture"
echo "  /sdlc:develop   - Phase 3: Development"
echo "  /sdlc:review    - Phase 4: Code Review"
echo "  /sdlc:test      - Phase 5: Testing"
echo ""
echo -e "${CYAN}Documentation:${NC}"
echo "  cat skills/sdlc/README.md"
echo ""
