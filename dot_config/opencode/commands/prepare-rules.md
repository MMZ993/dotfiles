---
description: Generates .agents/RULES.md from PRD for a new project — run after /brainstorm, before /plan
---

Read `.agents/PRD.md`. If it does not exist, stop and tell the user to run `/brainstorm` first.

If `.agents/RULES.md` already exists, inform the user and ask whether to update it or overwrite it before proceeding.

---

**1. Understand what is being built**
Read `.agents/PRD.md` fully. Identify: the core domain, key features, technical decisions already made, and any constraints stated in the PRD.

**2. Look up key dependencies and verify versions**
For any library, framework, or API central to the PRD, use the `find-docs` skill to look up its current version and conventions. 
Never rely on internal memory for version numbers — it is stale. 
Record the exact versions in RULES.md. Context is lost between sessions — RULES.md is the only reliable source of this information across sessions.

**3. Write `.agents/RULES.md`**

```markdown
# Rules

## Stack
<Languages, frameworks, and key libraries to use>

## Versions
<Exact versions of all key dependencies — verified via find-docs, not assumed>

## Project structure
<How the project should be organized, where things should live>

## Conventions
<Naming, formatting, patterns to follow>

## Libraries
<Which libraries to use for what — be specific, e.g. "use X for HTTP, not Y">

## Testing
<How tests should be structured, what framework, what coverage is expected>

## Do not
<Explicit anti-patterns, things to avoid, decisions already rejected>

## Open questions
<Anything unresolved that will affect implementation decisions>
```

Be specific and opinionated — vague rules are not followed. Every rule should be directly traceable to a decision in the PRD.

**4. Confirm**
Show the written RULES.md to the user and ask for confirmation. Adjust if needed.
