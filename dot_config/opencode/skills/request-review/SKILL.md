---
name: request-review
description: Package context for a structured review, call it ALWAYS before invoce code-reviewer agent
---

Invoke the `code-reviewer` agent with precisely packaged context. Do not write a freeform request — the reviewer needs structured input to give useful feedback.

## Prepare context before invoking

**1. Get the diff**
```
git diff <base-sha>..HEAD
```
If unsure of base SHA, use `git log --oneline` to find the commit before this session's work started.

**2. Gather**
- What was implemented — reference the goal from `.agents/PLAN.md`
- Which tasks were completed (list them)
- Any decisions or trade-offs made that deviate from the plan
- Any known rough edges or areas of uncertainty

## Invoke the code-reviewer agent

Pass the following as the agent's input:

```
## What was implemented
<PLAN.md goal + list of completed tasks>

## Diff
<git diff output>

## Decisions made
<Any deviations from plan, trade-offs, or judgment calls>

## Areas to focus on
<Anything you're unsure about or want specific feedback on>
```

## Acting on feedback

- **Critical issues** (broken behavior, security, data loss): fix immediately, re-run tests, re-request review
- **Important issues** (correctness, missing edge cases): fix before session wrapup
- **Minor issues** (style, naming, suggestions): note in `.agents/HANDOFF.md` if not fixing now
- Push back with technical reasoning if feedback is incorrect — do not implement blindly
