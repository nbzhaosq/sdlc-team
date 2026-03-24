#!/usr/bin/env node
/**
 * Post-install script for @nbzhaosq/sdlc-team
 * Runs after npm install to set up the package
 */

const fs = require('fs');
const path = require('path');

console.log('\n\x1b[36m╔════════════════════════════════════════════════════════════╗\x1b[0m');
console.log('\x1b[36m║         SDLC Sub-Agent Team - Post Install                 ║\x1b[0m');
console.log('\x1b[36m╚════════════════════════════════════════════════════════════╝\x1b[0m\n');

console.log('\x1b[32m✓ SDLC Team installed successfully!\x1b[0m\n');

console.log('\x1b[36mQuick Start:\x1b[0m');
console.log('  npx @nbzhaosq/sdlc-team init .\n');

console.log('\x1b[36mCommands:\x1b[0m');
console.log('  npx @nbzhaosq/sdlc-team init <dir>   - Initialize project');
console.log('  npx @nbzhaosq/sdlc-team help         - Show help\n');

console.log('\x1b[36mDocumentation:\x1b[0m');
console.log('  https://github.com/nbzhaosq/sdlc-team\n');
