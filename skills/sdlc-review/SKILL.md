---
name: sdlc:review
aliases: ["sdlc:code-review"]
description: Code Review phase skill for SDLC implementation workflow
---

# Code Review Phase Skill

**Phase:** 4 - Review
**Command:** `/sdlc:review` or `/sdlc:code-review`

## Purpose

Performs comprehensive code review of implementation artifacts, ensuring code quality, architecture compliance, security, and acceptance criteria verification.

## Inputs

- Implementation code (from `/sdlc:develop` phase)
- Architecture document (from `/sdlc:design` phase)
- Requirements (from `/sdlc:analyze` phase)
- Design specs (from `/sdlc:design` phase)

## Outputs

- `docs/sdlc/review-feedback.md` - Comprehensive review feedback with findings, recommendations, and approval status

## Checklist

The review phase must verify the following items:

- [ ] Code quality acceptable
- [ ] Architecture followed
- [ ] Security reviewed
- [ ] Performance checked
- [ ] Documentation complete

## Responsibilities

### 1. Code Quality Review
- Review implementation code for readability and maintainability
- Check adherence to coding standards and best practices
- Identify potential bugs or edge cases
- Evaluate error handling completeness

### 2. Architecture Compliance
- Verify implementation follows approved architecture
- Check component boundaries and responsibilities
- Validate design pattern usage
- Ensure integration points are correct

### 3. Security Review
- Check for common vulnerabilities (OWASP Top 10)
- Review input validation and sanitization
- Examine authentication and authorization
- Verify secure data handling practices

### 4. Performance Assessment
- Identify performance bottlenecks
- Review algorithmic complexity
- Check database query efficiency
- Assess resource usage patterns

### 5. Documentation Verification
- Ensure all functions/classes are documented
- Verify API documentation is accurate
- Check for inline code comments
- Confirm architectural decisions are recorded

### 6. Acceptance Criteria Validation
- Verify all requirements are implemented
- Check test coverage of acceptance criteria
- Validate edge cases are handled
- Ensure user stories are satisfied

## Workflow

1. **Load Context**
   - Read implementation files
   - Load architecture document
   - Load requirements and design specs

2. **Run Static Analysis**
   - Execute `scripts/run-linters.sh`
   - Review any warnings or errors
   - Note tooling limitations

3. **Perform Manual Review**
   - Walk through critical code paths
   - Review complex algorithms
   - Check integration points

4. **Generate Feedback**
   - Compile findings into structured report
   - Categorize issues (blocker, major, minor, info)
   - Provide specific code references
   - Suggest remediation steps

5. **Determine Status**
   - Approved: All criteria met, no blockers
   - Approved with conditions: Minor issues only
   - Needs revision: Major issues require fixes
   - Rejected: Blockers present, return to implementation

## Feedback Report Structure

```markdown
# Code Review Feedback

**Review Date:** [date]
**Reviewer:** [agent]
**Implementation:** [component name]

## Executive Summary
- Overall Status: [Approved/Approved with conditions/Needs revision/Rejected]
- Total Findings: [N]
- Blockers: [N]
- Major: [N]
- Minor: [N]
- Info: [N]

## Checklist Status
- [x] Code quality acceptable
- [x] Architecture followed
- [ ] Security reviewed
...

## Findings

### Blockers
[Bug fixes required before approval]

### Major Issues
[Significant concerns that should be addressed]

### Minor Issues
[Nice-to-have improvements]

### Observations
[Informational notes, not issues]

## Performance Assessment
[Performance-related findings]

## Security Assessment
[Security-related findings]

## Architecture Compliance
[Architecture-related findings]

## Recommendation
[Final recommendation and next steps]
```

## Success Criteria

The review phase is complete when:
- All checklist items have been evaluated
- Static analysis has been run and reviewed
- Comprehensive feedback report is generated
- Approval/rejection status is clearly communicated

## Transitions

- **To Implementation (Revision):** If blockers or major issues found
- **To Testing:** If approved or approved with conditions
