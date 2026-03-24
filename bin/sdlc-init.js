#!/usr/bin/env node
/**
 * SDLC Team - NPX Installer
 *
 * Usage:
 *   npx @nbzhaosq/sdlc-team init [target-dir]
 *   npx @nbzhaosq/sdlc-team init . --tool claude
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const REPO_URL = process.env.SDLC_REPO_URL || 'https://github.com/nbzhaosq/sdlc-team.git';
const BRANCH = process.env.SDLC_BRANCH || 'main';

// Parse arguments
const args = process.argv.slice(2);
const command = args[0] || 'init';
const targetDir = args.find(a => !a.startsWith('--')) || '.';
const tool = args.includes('--tool') ? args[args.indexOf('--tool') + 1] : 'auto';
const allTools = args.includes('--all');

// Colors
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
  nc: '\x1b[0m'
};

function log(color, message) {
  console.log(`${colors[color]}${message}${colors.nc}`);
}

function createDirectory(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
    log('green', `✓ Created ${dir}`);
  }
}

function copySkills(packageDir, targetPath) {
  const skillsSource = path.join(packageDir, 'skills');
  const skillsTarget = path.join(targetPath, 'skills');

  if (!fs.existsSync(skillsSource)) {
    log('yellow', '⚠ Skills directory not found in package, cloning from git...');
    execSync(`git clone --depth 1 --branch ${BRANCH} ${REPO_URL} /tmp/sdlc-team`, { stdio: 'inherit' });
    copyDir('/tmp/sdlc-team/skills', skillsTarget);
    execSync('rm -rf /tmp/sdlc-team');
  } else {
    copyDir(skillsSource, skillsTarget);
  }
}

function copyDir(src, dest) {
  createDirectory(dest);
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function createStateFile(targetPath) {
  const stateFile = path.join(targetPath, '.sdlc-state.json');

  if (fs.existsSync(stateFile)) {
    log('yellow', '⚠ .sdlc-state.json already exists, skipping');
    return;
  }

  const state = {
    project: '',
    current_phase: null,
    phases: {
      requirements: { status: 'pending' },
      architecture: { status: 'pending' },
      development: { status: 'pending' },
      review: { status: 'pending' },
      testing: { status: 'pending' }
    },
    artifacts: {},
    created_at: null,
    updated_at: null
  };

  fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));
  log('green', '✓ Created .sdlc-state.json');
}

function generateClaudeMd(targetPath, append = false) {
  const file = path.join(targetPath, 'CLAUDE.md');
  const marker = '# SDLC';

  const content = `
# SDLC Configuration

This project uses the SDLC pipeline for structured development.

## Project Info

- **Name**: [Project Name]
- **Tech Stack**: [e.g., TypeScript, React, Node.js, PostgreSQL]

## Quick Commands

| Command | Description |
|---------|-------------|
| \`/sdlc "feature"\` | Run full pipeline |
| \`/sdlc:analyze "feature"\` | Requirements only |
| \`/sdlc:design\` | Architecture only |
| \`/sdlc:develop\` | Implementation only |
| \`/sdlc:review\` | Code review only |
| \`/sdlc:test\` | Testing only |

## Phase Customizations

### Requirements Phase
- Template: default

### Architecture Phase
- Template: default

### Development Phase
- Test coverage minimum: 80%

### Review Phase
- Run: \`npm run lint && npm run typecheck\`

### Testing Phase
- Commands: \`npm test\`
- Coverage threshold: 80%
`;

  if (fs.existsSync(file)) {
    const existing = fs.readFileSync(file, 'utf8');
    if (existing.includes(marker)) {
      log('yellow', '⚠ CLAUDE.md already contains SDLC configuration');
      return;
    }
    fs.appendFileSync(file, content);
    log('green', '✓ Updated CLAUDE.md with SDLC configuration');
  } else {
    fs.writeFileSync(file, `# Project Configuration\n${content}`);
    log('green', '✓ Created CLAUDE.md with SDLC configuration');
  }
}

function generateAgentsMd(targetPath) {
  const file = path.join(targetPath, 'AGENTS.md');

  const content = `# Project Agents Configuration

This file configures AI assistants for this project.

## SDLC Pipeline Configuration

This project uses the SDLC (Software Development Lifecycle) pipeline.

### Workflow

1. **Requirements Analysis** - Document in \`docs/sdlc/requirements.md\`
2. **Architecture Design** - Create design in \`docs/sdlc/architecture.md\`
3. **Development** - Implement features following the architecture
4. **Code Review** - Review for quality, security, and performance
5. **Testing** - Verify acceptance criteria

### Quality Gates

- Test coverage minimum: 80%
- Run linters before completion
- Review for security implications (OWASP Top 10)
- Document complex logic

## Project Info

- **Tech Stack**: [Define here]
- **Testing**: [Define here]
`;

  if (fs.existsSync(file)) {
    log('yellow', '⚠ AGENTS.md already exists, skipping');
    return;
  }

  fs.writeFileSync(file, content);
  log('green', '✓ Created AGENTS.md');
}

function generateCursorrules(targetPath) {
  const file = path.join(targetPath, '.cursorrules');

  const content = `# SDLC Pipeline

Use the SDLC pipeline for structured development.

## Workflow

1. Requirements → \`docs/sdlc/requirements.md\`
2. Architecture → \`docs/sdlc/architecture.md\`
3. Development → Implement per architecture
4. Review → Quality and security checks
5. Testing → \`docs/sdlc/test-report.md\`

## Quality Requirements

- Test coverage: 80% minimum
- Run linters before completion
- Review security implications
`;

  if (fs.existsSync(file)) {
    log('yellow', '⚠ .cursorrules already exists, skipping');
    return;
  }

  fs.writeFileSync(file, content);
  log('green', '✓ Created .cursorrules');
}

function init(targetPath, toolOption) {
  log('cyan', '╔════════════════════════════════════════════════════════════╗');
  log('cyan', '║          SDLC Sub-Agent Team Installer                     ║');
  log('cyan', '╚════════════════════════════════════════════════════════════╝');
  console.log();

  // Resolve target path
  targetPath = path.resolve(targetPath);
  log('blue', `Target directory: ${targetPath}`);

  // Get package directory
  const packageDir = path.dirname(require.main.filename);
  const skillsInPackage = path.join(packageDir, 'skills');

  // Step 1: Create directories
  log('blue', '\n[1/4] Creating directory structure...');
  createDirectory(path.join(targetPath, 'docs/sdlc'));
  createDirectory(path.join(targetPath, '.sdlc/templates'));
  createDirectory(path.join(targetPath, '.sdlc/scripts'));
  createDirectory(path.join(targetPath, '.sdlc/standards'));

  // Step 2: Copy skills
  log('blue', '\n[2/4] Installing SDLC skills...');
  copySkills(packageDir, targetPath);

  // Step 3: Create state file
  log('blue', '\n[3/4] Creating pipeline state...');
  createStateFile(targetPath);

  // Step 4: Generate config files
  log('blue', '\n[4/4] Generating configuration...');

  const toolsToCreate = allTools ? ['claude', 'agents', 'cursor'] :
    toolOption === 'auto' ? ['claude'] : [toolOption];

  for (const t of toolsToCreate) {
    switch (t) {
      case 'claude':
        generateClaudeMd(targetPath);
        break;
      case 'agents':
        generateAgentsMd(targetPath);
        break;
      case 'cursor':
        generateCursorrules(targetPath);
        break;
    }
  }

  // Summary
  console.log();
  log('green', '╔════════════════════════════════════════════════════════════╗');
  log('green', '║                  ✓ Installation Complete                  ║');
  log('green', '╚════════════════════════════════════════════════════════════╝');
  console.log();
  log('cyan', 'Quick Start:');
  console.log('  /sdlc:analyze "Your feature description"');
  console.log();
  log('cyan', 'Commands:');
  console.log('  /sdlc:init      - Reinitialize');
  console.log('  /sdlc:analyze   - Phase 1: Requirements');
  console.log('  /sdlc:design    - Phase 2: Architecture');
  console.log('  /sdlc:develop   - Phase 3: Development');
  console.log('  /sdlc:review    - Phase 4: Code Review');
  console.log('  /sdlc:test      - Phase 5: Testing');
}

// Run
if (command === 'init' || command === 'install') {
  init(path.resolve(targetDir), tool);
} else if (command === 'help' || command === '--help') {
  console.log(`
SDLC Sub-Agent Team Installer

Usage:
  npx @nbzhaosq/sdlc-team init [target-dir] [options]

Options:
  --tool <name>    Specify AI tool (claude, cursor, agents)
  --all            Create config files for all tools

Examples:
  npx @nbzhaosq/sdlc-team init .
  npx @nbzhaosq/sdlc-team init . --tool cursor
  npx @nbzhaosq/sdlc-team init . --all
`);
} else {
  log('red', `Unknown command: ${command}`);
  log('yellow', 'Use "npx @nbzhaosq/sdlc-team help" for usage');
  process.exit(1);
}
