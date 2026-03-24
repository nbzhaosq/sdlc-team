---
name: Coding Standards
type: reference
description: Team coding standards and conventions for the Development phase
---

# Coding Standards

## General Principles

- **Clarity over cleverness** - Write code that is easy to understand
- **DRY** - Don't Repeat Yourself
- **YAGNI** - You Aren't Gonna Need It - don't build features for hypothetical future needs
- **SOLID** - Follow SOLID principles where applicable

## Code Organization

### File Structure

```
src/
├── components/    # Reusable UI components (if applicable)
├── services/      # Business logic and external API calls
├── utils/         # Helper functions
├── types/         # Type definitions (if applicable)
└── index.ts       # Main entry point
tests/
├── unit/          # Unit tests
└── integration/   # Integration tests
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | kebab-case | `user-service.ts` |
| Classes | PascalCase | `UserService` |
| Functions/Variables | camelCase | `getUserData` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES` |
| Private members | underscore prefix | `_internalMethod` |

## Code Style

### Formatting

- Use consistent indentation (2 or 4 spaces, be consistent)
- Maximum line length: 100 characters
- One statement per line
- Blank line between logical sections
- Trailing commas in multi-line lists/objects

### Comments

- Add comments to explain **why**, not **what**
- Document public APIs with inline documentation
- Keep comments up-to-date with code changes
- Avoid commented-out code (remove it instead)

## Error Handling

- Always handle potential errors
- Use appropriate error types
- Provide meaningful error messages
- Log errors appropriately
- Fail gracefully when possible

### Example Error Handling Pattern

```typescript
async function fetchData(id: string): Promise<Data> {
  try {
    const response = await api.get(`/data/${id}`);
    return validateResponse(response.data);
  } catch (error) {
    if (error instanceof ApiError) {
      logger.error(`Failed to fetch data: ${error.message}`);
      throw new DataFetchError('Unable to retrieve data', { cause: error });
    }
    throw error;
  }
}
```

## Testing

### Unit Test Principles

- Tests should be independent and isolated
- Use descriptive test names that describe behavior
- Arrange-Act-Assert pattern
- Mock external dependencies
- Test both success and failure cases

### Test Structure

```typescript
describe('UserService', () => {
  describe('getUser', () => {
    it('should return user data when found', async () => {
      // Arrange
      const userId = '123';
      const expected = { id: '123', name: 'Test User' };

      // Act
      const result = await userService.getUser(userId);

      // Assert
      expect(result).toEqual(expected);
    });

    it('should throw error when user not found', async () => {
      // Arrange & Act & Assert
      await expect(userService.getUser('999')).rejects.toThrow(UserNotFoundError);
    });
  });
});
```

## Security

- Never hardcode secrets or credentials
- Validate and sanitize all user inputs
- Use parameterized queries for database operations
- Implement proper authentication and authorization
- Follow principle of least privilege

## Performance

- Optimize only after measuring
- Avoid premature optimization
- Consider time and space complexity
- Use caching where appropriate
- Avoid unnecessary network calls

## Git Conventions

### Commit Messages

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(auth): add JWT token refresh mechanism

Implements automatic token refresh using refresh token stored
in secure HTTP-only cookies.

Closes #123
```

### Branch Naming

```
feature/ticket-description
fix/ticket-description
hotfix/ticket-description
```

## Code Review Checklist

- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Error handling is implemented
- [ ] No hardcoded values that should be configurable
- [ ] No commented-out debug code
- [ ] Log messages are appropriate
- [ ] Security best practices followed
- [ ] Performance considerations addressed
