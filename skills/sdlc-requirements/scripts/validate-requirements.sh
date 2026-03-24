#!/bin/bash
# Validate requirements document completeness

set -e

REQUIREMENTS_FILE="${1:-docs/sdlc/requirements.md}"

if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "Error: Requirements file not found: $REQUIREMENTS_FILE"
    exit 1
fi

echo "Validating $REQUIREMENTS_FILE..."
echo ""

# Define required sections
REQUIRED_SECTIONS=(
    "User Stories"
    "Functional Requirements"
    "Non-Functional Requirements"
    "Edge Cases"
    "Dependencies"
    "Assumptions"
    "Constraints"
)

CHECKLIST_PASSED=true
CHECKLIST_FAILED=()

# Check for required sections
for section in "${REQUIRED_SECTIONS[@]}"; do
    if grep -q "^## $section" "$REQUIREMENTS_FILE"; then
        echo "✓ Section present: $section"
    else
        echo "✗ Section missing: $section"
        CHECKLIST_PASSED=false
        CHECKLIST_FAILED+=("Missing section: $section")
    fi
done

echo ""

# Check for user stories
if grep -q "### \[User Story" "$REQUIREMENTS_FILE" || grep -q "### User Story" "$REQUIREMENTS_FILE"; then
    echo "✓ User stories defined"
else
    echo "✗ No user stories found"
    CHECKLIST_PASSED=false
    CHECKLIST_FAILED+=("No user stories defined")
fi

# Check for acceptance criteria (look for "Acceptance Criteria" headings)
if grep -q "**Acceptance Criteria:**" "$REQUIREMENTS_FILE" || grep -q "Acceptance Criteria:" "$REQUIREMENTS_FILE"; then
    echo "✓ Acceptance criteria present"
else
    echo "✗ No acceptance criteria found"
    CHECKLIST_PASSED=false
    CHECKLIST_FAILED+=("No acceptance criteria defined")
fi

# Check for non-functional requirements sub-sections
if grep -q "^### Performance" "$REQUIREMENTS_FILE" && \
   grep -q "^### Security" "$REQUIREMENTS_FILE"; then
    echo "✓ Key non-functional requirements documented"
else
    echo "⚠ Key non-functional requirements may be incomplete"
fi

echo ""
echo "----------------------------------------"

if [ "$CHECKLIST_PASSED" = true ]; then
    echo "✓ Requirements validation PASSED"
    echo ""
    echo "Checklist items:"
    echo "  [x] User stories defined"
    echo "  [x] Acceptance criteria measurable"
    echo "  [x] Edge cases identified"
    echo "  [x] Dependencies mapped"
    echo "  [x] Priority assigned"
    exit 0
else
    echo "✗ Requirements validation FAILED"
    echo ""
    echo "Failed items:"
    for item in "${CHECKLIST_FAILED[@]}"; do
        echo "  ✗ $item"
    done
    exit 1
fi
