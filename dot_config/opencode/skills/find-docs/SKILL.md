---
name: find-docs
description: Retrieves up-to-date documentation, API references, and code examples for any library or framework using Context7 CLI. Use for library docs, API references, configuration options, installation guides, and version verification. Not for searching the local codebase.
---

# Documentation Lookup

Retrieve current documentation and code examples for any library using Context7 CLI (`ctx7`).

## Two-step workflow

Always resolve the library ID first, then query docs. Never skip step 1.

```bash
# Step 1: resolve library name to an ID
ctx7 library <name> "<query>"

# Step 2: query documentation with that ID
ctx7 docs <libraryId> "<query>"
```

You may skip step 1 only if the user explicitly provides a library ID in the format `/org/project` or `/org/project/version`.

**Do not run more than 3 commands per question.** If you cannot find what you need after 3 attempts, use the best result available.

## Examples

```bash
ctx7 library next-auth "how to authenticate with credentials"
ctx7 docs /nextauthjs/next-auth "how to authenticate with credentials"

ctx7 library react "useEffect cleanup with async operations"
ctx7 docs /facebook/react "useEffect cleanup async"

ctx7 library prisma "one-to-many relations with cascade delete"
ctx7 docs /prisma/prisma "one-to-many relations cascade delete"
```

## Writing good queries

Always pass a full, descriptive query — it directly affects result quality.

| Good | Bad |
|------|-----|
| `"how to set up authentication middleware in Express"` | `"auth"` |
| `"React useEffect cleanup function with async operations"` | `"hooks"` |

Use the full question as the query. Single-word queries return generic results.

## Version-specific IDs

```bash
# latest indexed
ctx7 docs /vercel/next.js "app router middleware"

# specific version (versions listed in ctx7 library output)
ctx7 docs /vercel/next.js/v14.3.0-canary.87 "app router middleware"
```

Always record the verified version in `.agents/RULES.md`.

## Selecting the right library

When `ctx7 library` returns multiple matches, prefer:
1. Exact name match to the query
2. Higher Code Snippet count (more documentation coverage)
3. High or Medium source reputation
4. Higher benchmark score (100 is max)

## Error handling

**CLI not found:** Report to user. Do not install ctx7 yourself.

**Quota exceeded:** Inform the user. Suggest `ctx7 login` for higher limits. If unavailable, answer from training knowledge and explicitly state it may be outdated — never silently fall back.

**Library not found:** Suggest alternative names or query refinements.

**Network error:** Suggest retrying. If persistent, note the service may be temporarily unavailable.

## Common mistakes

- Library IDs require a `/` prefix — `/facebook/react` not `facebook/react`
- Always run `ctx7 library` first — `ctx7 docs react "hooks"` will fail without a valid ID
- Do not include sensitive information (API keys, passwords) in queries
