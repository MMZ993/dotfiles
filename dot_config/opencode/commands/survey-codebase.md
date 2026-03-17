---
description: Generates .agents/RULES.md by reading an existing codebase — run when onboarding to an existing project without a PRD
---

If `.agents/RULES.md` already exists, inform the user and ask whether to update it or overwrite it before proceeding.

---

**1. Survey the codebase structure**
Use the `explore` agent to get a broad understanding of the project:
- Top-level directory structure and module organization
- Languages and runtime versions in use
- Build system, package manager, configuration files

**2. Identify libraries and frameworks and verify versions**
Check `package.json`, `cargo.toml`, `pyproject.toml`, `go.mod`, or equivalent. 
List all significant dependencies. For each one, use the `find-docs` skill to verify the current version and look up its conventions — never rely on internal memory for version numbers, it is stale. 
Record exact versions in RULES.md. Context is lost between sessions — RULES.md is the only reliable source of this information across sessions.

**3. Read existing code patterns**
Use the `explore` agent to find representative files and understand:
- Naming conventions (files, functions, variables, types)
- Code organization within files
- Error handling patterns
- How tests are written and where they live
- How modules import and depend on each other

**4. Write `.agents/RULES.md`**

```markdown
# Rules

## Stack
<Languages, frameworks, and key libraries in use>

## Versions
<Exact versions of all key dependencies — verified via find-docs, not assumed>

## Project structure
<How the codebase is organized, where things live>

## Conventions
<Naming, formatting, patterns derived from existing code>

## Libraries
<Which libraries to use for what — be specific>

## Testing
<How tests are structured, what framework, where they live>

## Do not
<Anti-patterns found in the codebase, things explicitly avoided>

## Open questions
<Anything unclear that the user should clarify before planning>
```

Be specific and opinionated — vague rules are not followed. Every rule should be derived from what you actually observed in the code, not generic best practices.

**5. Confirm**
Show the written RULES.md to the user and ask for confirmation. Adjust if needed. Flag any open questions that need human input before planning can begin.
