---
name: commit
description: Create atomic conventional commits, call it ALWAYS before attempt to commit
---

## Conventional commit format

```
<type>: <description>
```

Types:
- `feat:` — new functionality
- `fix:` — bug fix
- `refactor:` — behavior unchanged, structure improved
- `test:` — tests only
- `chore:` — maintenance, dependencies, config
- `docs:` — documentation only

Description: imperative mood, lowercase, no period. Focus on *why*, not *what*. Be specific — "add rate limiting to login endpoint" not "improve security".

## Process

**1. Review changes**
Run `git status` and `git diff` to understand what changed. Group related changes into logical commits — one concern per commit.

**2. Present the plan**
Before staging anything, tell the user:
- How many commits you plan to create
- Which files go in each commit
- The commit message for each

Ask for confirmation.

**3. Execute**
- Stage specific files: `git add <file>` — never `git add .` or `git add -A`
- Commit with the planned message
- Show result with `git log --oneline -n <count>`

## Rules

- Never commit secrets, keys, or credentials
- Never use `--no-verify`
- Keep commits atomic — one logical change per commit
- If changes span multiple concerns, split into multiple commits
