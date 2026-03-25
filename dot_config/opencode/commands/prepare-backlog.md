---
description: Create or review/correct the Beads backlog from PRD — run before ralph to set up work items
---

# Prepare Beads Backlog

You may receive user instructions as a prompt argument. If provided, treat them as priority directives — apply them on top of the standard process below.

---

## Step 1 — Load context

Read all that exist:
- `.agents/PRD.md` — requirements, source of truth
- `.agents/RULES.md` — project conventions and stack

Get the project name: run `basename $(git rev-parse --show-toplevel)`.

---

## Step 2 — Check current Beads state

Run `bd epic list` and `bd task list`.

This determines which path to take:

**Path A — No epic or tasks exist yet:** you are building the backlog from scratch.

**Path B — Epic and/or tasks already exist:** you are reviewing and correcting an existing backlog. Note what is there, then continue — the same process applies, but you will also update, close, or split existing tasks where needed.

---

## Step 3 — Survey the codebase

Use the `explore` agent to understand current project state:
- What is already implemented
- What is partially implemented
- What is entirely missing

For a greenfield project this returns little or nothing — that is expected and fine.

---

## Step 4 — Derive tasks

Cross-reference PRD requirements against what the codebase survey found. Tasks represent work that is **not yet done**.

**Sizing rules — apply to every task:**
- One task = one coherent, focused piece of work completable in a single session
- If a requirement touches more than ~3 unrelated areas, or has more than ~4 distinct implementation steps — split it into multiple tasks
- Write at implementation level, not feature level:
  - ✓ "implement POST /synthesize endpoint with input validation"
  - ✗ "build TTS API"
- Order by dependency — foundational work first

**If user instructions were provided:** apply them now — add, remove, rename, reorder, or split tasks as directed. User instructions take priority over your own judgment.

---

## Step 5 — Sync Beads

```
# Create epic if it doesn't exist
bd epic create "<project-name>"

# Create each task
bd task create "<description>" --epic <id>

# Close tasks that are already fully implemented (Path B only)
bd task update <id> --status done

# Correct existing tasks per user instructions (Path B only)
bd task update <id> ...
```

Do not create duplicate tasks — if a task with a matching description already exists in Beads, skip it.

---

## Step 6 — Show and confirm

Display the full resulting task list — every open task, in order.

Ask the user to confirm, or provide corrections. If they give corrections: apply them immediately, show the updated list, and ask again. Repeat until confirmed.
