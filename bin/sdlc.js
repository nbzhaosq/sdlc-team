#!/usr/bin/env node
/**
 * SDLC Team - CLI Entry Point
 *
 * Usage:
 *   npx @nbzhaosq/sdlc-team <command>
 */

const commands = {
  init: 'Initialize SDLC in current project',
  install: 'Alias for init',
  help: 'Show this help message',
  version: 'Show version'
};

const args = process.argv.slice(2);
const command = args[0] || 'help';

if (command === 'help' || command === '--help' || command === '-h') {
  console.log(`
SDLC Sub-Agent Team - Software Development Lifecycle Pipeline

Usage:
  npx @nbzhaosq/sdlc-team <command> [options]

Commands:
  init [dir]        Initialize SDLC in target directory
                    Options: --tool <name>, --all
  install           Alias for init
  help              Show this help
  version           Show version

Examples:
  npx @nbzhaosq/sdlc-team init .
  npx @nbzhaosq/sdlc-team init . --tool claude
  npx @nbzhaosq/sdlc-team init . --all

After installation, use in your AI tool:
  /sdlc:analyze "Feature description"
  /sdlc:design
  /sdlc:develop
  /sdlc:review
  /sdlc:test

For more information:
  https://github.com/nbzhaosq/sdlc-team
`);
} else if (command === 'version' || command === '--version' || command === '-v') {
  const pkg = require('../package.json');
  console.log(`@nbzhaosq/sdlc-team v${pkg.version}`);
} else if (command === 'init' || command === 'install') {
  require('./sdlc-init.js');
} else {
  console.log(`Unknown command: ${command}`);
  console.log('Use "npx @nbzhaosq/sdlc-team help" for usage');
  process.exit(1);
}
