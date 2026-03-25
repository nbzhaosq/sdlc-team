#!/usr/bin/env node
/**
 * SDLC Team - Unified CLI Entry Point
 *
 * Usage:
 *   npx @nbzhaosq/sdlc-team init [target-dir] --tool <tool>
 *   npx @nbzhaosq/sdlc-team help
 */

const fs = require('fs');
const path = require('path');

// Supported AI tools configuration
const TOOLS = {
  'claude-code': {
    name: 'Claude Code',
    skillsDir: '.claude/skills',
    configFile: 'CLAUDE.md',
    commandPrefix: '/sdlc'
  },
  'opencode': {
    name: 'OpenCode',
    skillsDir: '.opencode/skills',
    configFile: 'OPENCODE.md',
    commandPrefix: '/sdlc'
  },
  'qodercli': {
    name: 'QoderCLI',
    skillsDir: '.qoder/skills',
    configFile: 'QODER.md',
    commandPrefix: '/sdlc'
  },
  'cursor': {
    name: 'Cursor',
    skillsDir: '.cursor/skills',
    configFile: '.cursorrules',
    commandPrefix: 'Cmd+K'
  },
  'generic': {
    name: 'Generic (AGENTS.md)',
    skillsDir: 'skills',
    configFile: 'AGENTS.md',
    commandPrefix: 'workflow'
  }
};

// Colors
const c = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
  bold: '\x1b[1m',
  nc: '\x1b[0m'
};

function log(color, msg) {
  console.log(`${c[color]}${msg}${c.nc}`);
}

// Valid commands that can be specified
const VALID_COMMANDS = ['init', 'install', 'help'];

function parseArgs(args) {
  const result = {
    command: 'init',  // default command
    targetDir: '.',   // default target directory
    tool: null,
    all: false,
    help: false
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg === '--tool' || arg === '-t') {
      result.tool = args[++i];
    } else if (arg === '--all' || arg === '-a') {
      result.all = true;
    } else if (arg === '--help' || arg === '-h' || arg === 'help') {
      result.help = true;
    } else if (!arg.startsWith('-')) {
      // If it's a valid command and we haven't set a non-default command yet
      if (VALID_COMMANDS.includes(arg) && result.command === 'init') {
        result.command = arg;
      } else {
        // Otherwise it's the target directory
        result.targetDir = arg;
      }
    }
  }

  return result;
}

function promptToolSelection() {
  console.log();
  log('cyan', `${c.bold}Select your AI tool:${c.nc}`);
  console.log();

  const toolList = Object.keys(TOOLS);
  toolList.forEach((key, index) => {
    const tool = TOOLS[key];
    console.log(`  ${c.cyan}${index + 1}.${c.nc} ${c.bold}${tool.name}${c.nc}`);
    console.log(`     Skills dir: ${tool.skillsDir}`);
    console.log(`     Config: ${tool.configFile}`);
    console.log();
  });

  console.log(`  ${c.cyan}a.${c.nc} ${c.bold}All tools${c.nc} (install for all)`);
  console.log();

  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(`Enter choice [1-${toolList.length}/a]: `, (answer) => {
      rl.close();
      answer = answer.trim().toLowerCase();

      if (answer === 'a' || answer === 'all') {
        resolve('all');
      } else {
        const index = parseInt(answer) - 1;
        if (index >= 0 && index < toolList.length) {
          resolve(toolList[index]);
        } else {
          log('yellow', 'Invalid choice, defaulting to claude-code');
          resolve('claude-code');
        }
      }
    });
  });
}

function getPackageDir() {
  let dir = __dirname;
  while (dir !== '/') {
    if (fs.existsSync(path.join(dir, 'skills', 'sdlc', 'SKILL.md'))) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return __dirname;
}

function copyDir(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }

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
    log('yellow', '  ⚠ .sdlc-state.json exists, skipping');
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
  log('green', '  ✓ Created .sdlc-state.json');
}

function generateConfig(toolKey, targetPath) {
  const tool = TOOLS[toolKey];
  const configFile = path.join(targetPath, tool.configFile);

  const configs = {
    'CLAUDE.md': `# SDLC Configuration

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
`,

    'OPENCODE.md': `# SDLC Configuration

This project uses the SDLC pipeline for structured development.

## Project Info

- **Name**: [Project Name]
- **Tech Stack**: [e.g., TypeScript, React, Node.js]

## Quick Commands

| Command | Description |
|---------|-------------|
| \`/sdlc "feature"\` | Run full pipeline |
| \`/sdlc:analyze\` | Requirements |
| \`/sdlc:design\` | Architecture |
| \`/sdlc:develop\` | Development |
| \`/sdlc:review\` | Review |
| \`/sdlc:test\` | Testing |

## Quality Gates

- Test coverage: 80% minimum
- Run linters before commit
`,

    'QODER.md': `# SDLC Configuration

This project uses the SDLC pipeline for structured development.

## Project Info

- **Name**: [Project Name]
- **Tech Stack**: [e.g., TypeScript, React, Node.js]

## Quick Commands

| Command | Description |
|---------|-------------|
| \`/sdlc "feature"\` | Run full pipeline |
| \`/sdlc:analyze\` | Requirements |
| \`/sdlc:design\` | Architecture |
| \`/sdlc:develop\` | Development |
| \`/sdlc:review\` | Review |
| \`/sdlc:test\` | Testing |

## Quality Gates

- Test coverage: 80% minimum
`,

    '.cursorrules': `# SDLC Configuration

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

## Tech Stack

[Define your tech stack here]
`,

    'AGENTS.md': `# Project Configuration

This file configures AI assistants for this project.

## SDLC Pipeline

This project uses the SDLC pipeline for structured development.

### Workflow

1. **Requirements** - Document in \`docs/sdlc/requirements.md\`
2. **Architecture** - Design in \`docs/sdlc/architecture.md\`
3. **Development** - Implement per architecture
4. **Review** - Quality and security checks
5. **Testing** - Verify in \`docs/sdlc/test-report.md\`

### Quality Gates

- Test coverage minimum: 80%
- Run linters before completion

## Project Info

- **Tech Stack**: [Define here]
`
  };

  if (fs.existsSync(configFile)) {
    log('yellow', `  ⚠ ${tool.configFile} exists, skipping`);
    return;
  }

  fs.writeFileSync(configFile, configs[tool.configFile] || configs['AGENTS.md']);
  log('green', `  ✓ Created ${tool.configFile}`);
}

function installForTool(toolKey, targetPath, packageDir) {
  const tool = TOOLS[toolKey];

  log('cyan', `\n${c.bold}Installing for ${tool.name}:${c.nc}`);
  log('blue', `  Skills directory: ${tool.skillsDir}`);

  // Create skills directory
  const skillsDest = path.join(targetPath, tool.skillsDir);

  // Copy skills
  const skillsSource = path.join(packageDir, 'skills');
  copyDir(skillsSource, skillsDest);
  log('green', '  ✓ Copied SDLC skills');

  // Create docs/sdlc directory
  const docsDir = path.join(targetPath, 'docs', 'sdlc');
  if (!fs.existsSync(docsDir)) {
    fs.mkdirSync(docsDir, { recursive: true });
    log('green', '  ✓ Created docs/sdlc/');
  }

  // Create .sdlc directory for customizations
  const sdlcDir = path.join(targetPath, '.sdlc');
  if (!fs.existsSync(sdlcDir)) {
    fs.mkdirSync(sdlcDir, { recursive: true });
    fs.mkdirSync(path.join(sdlcDir, 'templates'), { recursive: true });
    fs.mkdirSync(path.join(sdlcDir, 'scripts'), { recursive: true });
    log('green', '  ✓ Created .sdlc/');
  }

  // Create state file
  createStateFile(targetPath);

  // Generate config file
  generateConfig(toolKey, targetPath);
}

async function init(options) {
  log('cyan', '\n╔════════════════════════════════════════════════════════════╗');
  log('cyan', '║         SDLC Sub-Agent Team Installer                      ║');
  log('cyan', '╚════════════════════════════════════════════════════════════╝');

  const targetPath = path.resolve(options.targetDir);
  log('blue', `\nTarget: ${targetPath}`);

  // Determine which tool(s) to install for
  let toolsToInstall = [];

  if (options.all) {
    toolsToInstall = Object.keys(TOOLS);
  } else if (options.tool) {
    if (!TOOLS[options.tool]) {
      log('red', `Unknown tool: ${options.tool}`);
      log('yellow', `Available: ${Object.keys(TOOLS).join(', ')}`);
      process.exit(1);
    }
    toolsToInstall = [options.tool];
  } else {
    // Interactive selection
    const selected = await promptToolSelection();
    if (selected === 'all') {
      toolsToInstall = Object.keys(TOOLS);
    } else {
      toolsToInstall = [selected];
    }
  }

  // Get package directory
  const packageDir = getPackageDir();

  // Install for each tool
  for (const toolKey of toolsToInstall) {
    installForTool(toolKey, targetPath, packageDir);
  }

  // Summary
  log('green', '\n╔════════════════════════════════════════════════════════════╗');
  log('green', '║                  ✓ Installation Complete                   ║');
  log('green', '╚════════════════════════════════════════════════════════════╝');

  log('cyan', '\nInstalled for:');
  for (const toolKey of toolsToInstall) {
    const tool = TOOLS[toolKey];
    console.log(`  • ${tool.name} (${tool.skillsDir})`);
  }

  log('cyan', '\nNext steps:');
  log('yellow', '  1. Edit config file to customize SDLC settings');
  log('yellow', '  2. Start with: /sdlc:analyze "Your feature"');

  log('cyan', '\nCommands:');
  console.log('  /sdlc "feature"    - Run full pipeline');
  console.log('  /sdlc:analyze     - Phase 1: Requirements');
  console.log('  /sdlc:design      - Phase 2: Architecture');
  console.log('  /sdlc:develop     - Phase 3: Development');
  console.log('  /sdlc:review      - Phase 4: Code Review');
  console.log('  /sdlc:test        - Phase 5: Testing');
}

function showHelp() {
  console.log(`
${c.bold}SDLC Sub-Agent Team${c.nc} - Complete SDLC pipeline as agent skills

${c.cyan}Usage:${c.nc}
  npx @nbzhaosq/sdlc-team init [dir] [options]
  npx @nbzhaosq/sdlc-team help

${c.cyan}Options:${c.nc}
  --tool, -t <name>    Specify AI tool (interactive if not provided)
  --all, -a             Install for all supported tools

${c.cyan}Supported Tools:${c.nc}`);

  for (const [key, tool] of Object.entries(TOOLS)) {
    console.log(`  ${c.bold}${key.padEnd(12)}${c.nc} - ${tool.name}`);
    console.log(`               Skills: ${tool.skillsDir}`);
    console.log(`               Config: ${tool.configFile}`);
  }

  console.log(`
${c.cyan}Examples:${c.nc}
  npx @nbzhaosq/sdlc-team init .                    # Interactive selection
  npx @nbzhaosq/sdlc-team init . --tool claude-code # Install for Claude Code
  npx @nbzhaosq/sdlc-team init . --tool opencode    # Install for OpenCode
  npx @nbzhaosq/sdlc-team init . --tool qodercli    # Install for QoderCLI
  npx @nbzhaosq/sdlc-team init . --all              # Install for all tools
`);
}

// Main
const args = process.argv.slice(2);
const options = parseArgs(args);

if (options.help || options.command === 'help') {
  showHelp();
} else if (options.command === 'init' || options.command === 'install' || args.length === 0) {
  init(options);
} else {
  log('red', `Unknown command: ${options.command}`);
  showHelp();
  process.exit(1);
}
