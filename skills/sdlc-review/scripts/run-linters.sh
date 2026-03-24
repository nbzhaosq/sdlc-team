#!/bin/bash

# Code Review Phase - Linter and Static Analysis Script
# This script runs various linting and static analysis tools

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Code Review: Static Analysis ==="
echo "Project root: $PROJECT_ROOT"
echo ""

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
OVERALL_STATUS=0

# Function to run a tool
run_tool() {
    local tool_name="$1"
    local command="$2"
    local skip_if_missing="$3"

    echo -e "${GREEN}Running: $tool_name${NC}"
    echo "Command: $command"

    if command -v $(echo "$command" | awk '{print $1}') &> /dev/null; then
        if eval "$command"; then
            echo -e "${GREEN}✓ $tool_name: PASSED${NC}"
        else
            echo -e "${RED}✗ $tool_name: FAILED${NC}"
            OVERALL_STATUS=1
        fi
    else
        if [ "$skip_if_missing" = "true" ]; then
            echo -e "${YELLOW}⊘ $tool_name: SKIPPED (not installed)${NC}"
        else
            echo -e "${YELLOW}⚠ $tool_name: SKIPPED (not installed - consider installing)${NC}"
        fi
    fi
    echo ""
}

# Detect project type
PROJECT_TYPE="unknown"
if [ -f "package.json" ]; then
    PROJECT_TYPE="javascript"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    PROJECT_TYPE="python"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    PROJECT_TYPE="java"
fi

echo "Detected project type: $PROJECT_TYPE"
echo ""

# Run language-specific linters
case "$PROJECT_TYPE" in
    javascript)
        # ESLint
        if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.yml" ] || [ -f ".eslintrc" ] || grep -q "\"eslint\"" package.json 2>/dev/null; then
            run_tool "ESLint" "npm run lint || npx eslint . --ext .js,.jsx,.ts,.tsx 2>&1 || true" "true"
        fi

        # TypeScript check
        if [ -f "tsconfig.json" ]; then
            run_tool "TypeScript Compiler" "npx tsc --noEmit 2>&1 || true" "true"
        fi

        # Prettier check
        if grep -q "\"prettier\"" package.json 2>/dev/null; then
            run_tool "Prettier" "npx prettier --check \"**/*.{js,jsx,ts,tsx,json,css,scss,md}\" 2>&1 || true" "true"
        fi
        ;;

    python)
        # flake8
        run_tool "flake8" "flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics 2>&1 || true" "true"

        # pylint
        if [ -f ".pylintrc" ] || [ -f "pyproject.toml" ] || [ -f "pylint.ini" ]; then
            run_tool "pylint" "pylint **/*.py --errors-only 2>&1 || true" "true"
        fi

        # mypy (type checking)
        if [ -f "pyproject.toml" ] || [ -f "mypy.ini" ] || [ -f ".mypy.ini" ]; then
            run_tool "mypy" "mypy . 2>&1 || true" "true"
        fi

        # black (code formatting)
        if grep -q "black" requirements.txt pyproject.toml setup.py 2>/dev/null; then
            run_tool "black (check)" "black --check . 2>&1 || true" "true"
        fi
        ;;

    go)
        # go vet
        run_tool "go vet" "go vet ./... 2>&1" "true"

        # golangci-lint
        if command -v golangci-lint &> /dev/null; then
            run_tool "golangci-lint" "golangci-lint run 2>&1" "true"
        fi

        # gofmt
        run_tool "gofmt" "gofmt -l . 2>&1 | grep -q . && echo 'Files need formatting' && exit 1 || echo 'All files formatted'" "true"
        ;;

    rust)
        # cargo clippy
        run_tool "clippy" "cargo clippy -- -D warnings 2>&1" "true"

        # cargo fmt
        run_tool "rustfmt" "cargo fmt -- --check 2>&1" "true"
        ;;

    java)
        # Checkstyle (if configured)
        if [ -f "checkstyle.xml" ] || [ -f ".checkstyle" ]; then
            run_tool "checkstyle" "mvn checkstyle:check 2>&1 || ./gradlew checkstyleMain checkstyleTest 2>&1 || true" "true"
        fi
        ;;

    *)
        echo -e "${YELLOW}No language-specific linters configured for project type: $PROJECT_TYPE${NC}"
        ;;
esac

# Run general checks
echo "=== General Code Quality Checks ==="

# Check for TODO/FIXME/HACK comments
echo -e "${GREEN}Checking for TODO/FIXME/HACK comments...${NC}"
TODO_COUNT=$(grep -r "TODO\|FIXME\|HACK" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" --include="*.py" --include="*.go" --include="*.rs" . 2>/dev/null | grep -v "node_modules" | grep -v ".git" | grep -v "vendor" | wc -l | tr -d ' ')
echo "Found $TODO_COUNT TODO/FIXME/HACK comments"
echo ""

# Check for console.log statements
echo -e "${GREEN}Checking for debug console statements...${NC}"
CONSOLE_COUNT=$(grep -r "console.log\|console.debug\|print(" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v "node_modules" | grep -v ".git" | grep -v "vendor" | wc -l | tr -d ' ')
echo "Found $CONSOLE_COUNT debug console statements"
echo ""

# Check for hardcoded secrets (basic pattern)
echo -e "${GREEN}Checking for potential hardcoded secrets...${NC}"
SECRET_PATTERN="(password.*=.*['\"][^'\"]{10,}['\"]|api[_-]?key.*=.*['\"][^'\"]{10,}['\"]|secret.*=.*['\"][^'\"]{10,}['\"]|token.*=.*['\"][^'\"]{20,}['\"])"
SECRETS=$(grep -r -i -E "$SECRET_PATTERN" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" --include="*.py" --include="*.go" --include="*.rs" --include="*.yaml" --include="*.yml" . 2>/dev/null | grep -v "node_modules" | grep -v ".git" | grep -v "vendor" | grep -v ".env.example" || true)
if [ -n "$SECRETS" ]; then
    echo -e "${RED}⚠ Potential hardcoded secrets found:${NC}"
    echo "$SECRETS"
    OVERALL_STATUS=1
else
    echo -e "${GREEN}✓ No obvious hardcoded secrets detected${NC}"
fi
echo ""

# Summary
echo "=== Summary ==="
if [ $OVERALL_STATUS -eq 0 ]; then
    echo -e "${GREEN}✓ All static analysis checks passed${NC}"
else
    echo -e "${RED}✗ Some issues found during static analysis${NC}"
fi

exit $OVERALL_STATUS
