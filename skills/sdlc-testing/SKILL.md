---
name: sdlc:testing
aliases:
  - "sdlc:test"
  - "sdlc:verify"
description: Testing & Verification Phase - Phase 5 of SDLC. Execute test suites, verify acceptance criteria, and generate test reports.
---

# Testing & Verification Phase

**Phase 5 of SDLC**

This skill handles the Testing & Verification phase of the SDLC lifecycle. It executes test suites, verifies acceptance criteria, performs performance testing, and generates a comprehensive test report.

## Inputs

- Implementation code from the Development phase
- Review approval from Code Review phase
- Project requirements and specifications

## Outputs

- `docs/sdlc/test-report.md` - Comprehensive test report

## Checklist

Run through this checklist during the testing phase:

- [ ] All tests pass
- [ ] Acceptance criteria verified
- [ ] Performance benchmarks met
- [ ] No critical bugs
- [ ] Ready for deployment

## Responsibilities

1. **Run Test Suites**
   - Execute unit tests
   - Run integration tests
   - Run end-to-end tests if available

2. **Verify Acceptance Criteria**
   - Cross-check each requirement with test results
   - Document any gaps or deviations
   - Ensure all functional requirements are met

3. **Performance Testing**
   - Run performance benchmarks
   - Check memory usage and resource consumption
   - Verify response times meet requirements

4. **Bug Analysis**
   - Document any critical bugs found
   - Categorize issues by severity
   - Provide recommendations for fixes

5. **Generate Test Report**
   - Compile all test results into `docs/sdlc/test-report.md`
   - Include test coverage metrics
   - Provide sign-off recommendation

## Usage

Invoke this skill after code review is complete and before deployment:

```
/sdlc:test
```

or

```
/sdlc:testing
```

The skill will:
1. Execute the test suite using `scripts/run-tests.sh`
2. Analyze test results
3. Verify against requirements
4. Generate the test report
5. Provide a deployment recommendation
