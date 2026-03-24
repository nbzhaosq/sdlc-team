#!/bin/bash
# Run test suites for the Testing & Verification phase

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Running Test Suites ==="
echo ""

# Detect available test frameworks
if command -v npm &> /dev/null && [ -f "package.json" ]; then
    echo "Running Node.js tests..."
    if grep -q "\"test\"" package.json; then
        npm test
    else
        echo "No test script found in package.json"
    fi
elif command -v python &> /dev/null && [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    echo "Running Python tests..."
    if command -v pytest &> /dev/null; then
        pytest
    elif command -v unittest &> /dev/null; then
        python -m unittest discover
    else
        echo "No test framework found for Python"
    fi
elif command -v go &> /dev/null && [ -f "go.mod" ]; then
    echo "Running Go tests..."
    go test ./...
elif command -v mvn &> /dev/null && [ -f "pom.xml" ]; then
    echo "Running Maven tests..."
    mvn test
elif command -v gradle &> /dev/null && [ -f "build.gradle" ]; then
    echo "Running Gradle tests..."
    gradle test
else
    echo "No recognized test framework found in project."
    echo "Please configure tests for your project or run tests manually."
fi

echo ""
echo "=== Test Suite Execution Complete ==="
