---
description: Creates .agents/PLAN.md for the current session and syncs with td backlog
---

Read the following files to gather context — skip any that don't exist:
- `.agents/PRD.md` — project requirements
- `.agents/RULES.md` — project conventions
- `.agents/HANDOFF.md` — carry-over from last session
- Run `td task list` to see open td tasks

When navigating the codebase to understand scope or dependencies, use the `explore` agent. 
When you need library or API documentation, use the `find-docs` skill.

---

**1. Understand the scope**
- If PRD.md exists: derive tasks from its requirements
- If HANDOFF.md exists: pick up where last session left off
- Cross-reference open td tasks — include any that belong in this session
- Ask the user if scope is unclear — one focused question

**2. Check existing plan**
If `.agents/PLAN.md` already exists and has unchecked tasks, raise this with the user before writing a new one. Do not silently overwrite an unfinished plan.

**3. Sync with td**
- If no epic exists yet: `td epic create "<project name>"` first
- For each task not yet in td: `td task create "<description>" --epic <id>`
- For tasks carried over from a previous session: `td update <id> --status in_progress`
- Use `td help` if unsure about available commands

**4. Write `.agents/PLAN.md`**
Create a focused session plan — only what can reasonably be completed this session:

```markdown
# Session Plan — <date>

## Goal
<One sentence: what will be done this session>

## Tasks
- [ ] <task description> (td:<task-id>)
- [ ] <task description> (td:<task-id>)

## Notes
<Any constraints, decisions, or context relevant to this session>
```

Link each task to its td ID so progress stays in sync.

**5. Confirm**
Show the plan to the user and ask for confirmation before finishing. Adjust if needed.
