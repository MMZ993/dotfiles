---
description: Autonomous plan+dev loop iteration — validates previous session, plans, executes TDD, commits, writes HANDOFF and RALPH status
---

# Autonomous Mode

You are running inside an automated loop. **There is no user present.** Do not ask for confirmations. Do not wait for input. Make decisions and proceed. When you are truly stuck and cannot continue, write a detailed HANDOFF.md and stop — do not loop waiting for a response that will never come.

The iteration number and previous status are passed as your prompt argument. Read them, then verify against `.agents/RALPH.md` yourself.

---

# RALPH.md — Strict Format

This file is machine-parsed by the loop script. Follow this format exactly, no exceptions:

```
iteration 1: success
iteration 2: failed - <one line reason>
iteration 3: success
iteration 4: complete
```

Rules:
- One line per iteration, always
- Status is exactly one of: `success`, `failed`, `complete` (note that "complete" indicate WHOLE project finished, not only this iteration, never write complete if You are not 100% sure about it, just let next iteration handle it)
- `failed` must be followed by ` - ` and a single-line reason (no newlines)
- Never modify or delete previous lines — append only (except of last line in terms of previous iteration checks failed - see step 2)
- Writing this line is your **absolute last action** before stopping
- If RALPH.md does not exist yet, create it

---

# Step 1 — Load Context

Silently read all that exist:
- `.agents/PRD.md`
- `.agents/RULES.md`
- `.agents/HANDOFF.md`
- `.agents/RALPH.md`

Verify that the iteration number in your prompt matches the expected next line in RALPH.md (line count + 1). If there is a mismatch, note it and use the RALPH.md line count as ground truth.

---

# Step 2 — Validate Previous Iteration

**Skip this step only on iteration 1 (no previous session exists).**

Run all of the following checks regardless of what the previous status claims:

1. **Tests** — run the full test suite from `.agents/RULES.md`. Must pass cleanly.
2. **Lint** — run the lint command from `.agents/RULES.md`. Must pass with no errors.
3. **Git state** — run `git status`. Must be clean — no uncommitted changes, no untracked files that should be committed.
4. **PLAN.md** — read `.agents/PLAN.md`. Every task must be `[x]`. If unchecked tasks remain, validation fails.
5. **Beads** — run `bd task list`. No tasks should be `in-progress`. Open tasks are new work, not a failure.

**If all 5 checks pass:** previous iteration was genuinely successful..

**If any check fails:** downgrade the previous iteration in RALPH.md — overwrite the last line changing `success` to `failed - <what failed>`. Then proceed to the Recovery Fork below.

---

# Step 3 — Fork

## Fork A — Recovery (previous = failed, or just downgraded)

Read `.agents/HANDOFF.md` carefully — focus on what failed, what was tried, and what was suggested as next step.

Run `git log --oneline -10` to understand recent change history.

Attempt a targeted fix:
- Do not redo everything — focus on what the HANDOFF says went wrong
- If tests were failing: diagnose with the `debugging` skill, fix, then invoke the `verify` skill
- If git was dirty: stage and commit what was left, or revert if the changes are wrong
- If PLAN.md had unchecked tasks: complete them following the normal TDD loop (Step 5)

After the fix, re-run all 5 validation checks from Step 2.

If recovery succeeds: proceed to Step 4 (plan next work) as a normal iteration.

If recovery fails:
- Write a detailed `.agents/HANDOFF.md` (see Step 7 — Failure variant)
- Write RALPH.md: `iteration N: failed - recovery unsuccessful, <what was tried>`
- Stop.

---

## Fork B — Normal iteration (previous = success, or iteration 1)

Proceed to Step 4.

---

# Step 4 — Check Completion

Run `bd task list`. If there are **no open or in-progress tasks** and PLAN.md (if it exists) has all tasks checked off:

- Write `.agents/HANDOFF.md` with a completion summary
- Write RALPH.md: `iteration N: complete - all tasks done`
- Write 'complete' to `.agents/RALPH.md` ONLY in case this iteration You didnt wrote any new code, all tests passed, and there is no new items to implement from PRD.md file. If You did any code changes wrote `success`
- Stop. The project is finished.

If open tasks remain, continue to Step 5.

---

# Step 5 — Plan

Read current open Beads tasks: `bd task list`. Cross-reference with `.agents/PRD.md` requirements and `.agents/HANDOFF.md` carry-over.

Determine what to work on this iteration — scope it to what is achievable in one session. Prefer completing in-progress work before starting new tasks.

Sync Beads:
- If no epic exists: `bd epic create "<project name>"` first
- For new tasks not yet in Beads: `bd task create "<description>" --epic <id>`
- For tasks being picked up: `bd task update <id> --status in-progress`

Write `.agents/PLAN.md`:

```markdown
# Session Plan — <date> — Iteration <N>

## Goal
<One sentence: what will be accomplished this iteration>

## Tasks
- [ ] <task description> (bd:<task-id>)

## Notes
<Constraints, decisions, carry-over context>
```

No confirmation needed. Proceed immediately.

---

# Step 6 — Execute (TDD Loop)

Work through every task in PLAN.md. Do not skip steps. Do not move to the next task until the current one is verified.

When navigating unfamiliar code: use the `explore` agent for broad questions, Serena tools for targeted symbol lookups.
When you need library or API documentation: use the `find-docs` skill.

### For each task:

**1. Write a failing test — invoke `write-tests` skill**
Run it. Confirm it fails for the right reason before writing any implementation.

**2. Implement**
Minimum code to make the test pass. Follow `.agents/RULES.md`.

**3. Verify — invoke `verify` skill**
Full suite + lint must pass. If it fails, invoke the `debugging` skill. Identify root cause before changing anything. After fixing, return to verify. If root cause cannot be identified after thorough debugging: skip to Step 7 (Failure variant) — do not guess and commit broken code.

**4. Update tracking**
- Check off in PLAN.md: `- [x]`
- `bd task update <id> --status done`

---

### When all tasks are checked off:

**5. Request code review — invoke `request-review` skill, then call `code-reviewer` agent**
Act on feedback: fix critical and important issues, re-verify after each fix. Note minor issues in HANDOFF.md.

**6. Commit — invoke `commit` skill**
Autonomous mode — no confirmation step. You are a judge, there is no user. Stage specific files, commit with the planned message, verify with `git log`.

---

# Step 7 — Write HANDOFF.md

### On success:

```markdown
# Handoff — Iteration <N> — <date>

## Completed
<List of tasks completed this iteration>

## State
Tests passing, lint clean, git clean, all tasks committed.

## Next
<What remains — open Beads tasks, known gaps, suggested focus for next iteration>

## Notes
<Any decisions made, trade-offs, things to be aware of>
```

### On failure:

Write more detail — the next iteration's recovery depends on this:

```markdown
# Handoff — Iteration <N> — FAILED — <date>

## What was attempted
<What tasks were being worked on>

## What failed
<Exact failure — test name, error message, command output summary>

## What was tried
<Approaches attempted to fix it>

## Current state
<Git status, which tasks are checked off, what is uncommitted>

## Suggested next step
<What to try differently — be specific>
```

---

# Step 8 — Write RALPH.md (last action)

This is your final action. Do not do anything after this.

- **Success:** `iteration N: success`
- **Failure:** `iteration N: failed - <one line reason>`
- **Complete:** `iteration N: complete - all tasks done`

Append to `.agents/RALPH.md`. Never modify previous lines.

**After writing to RALPH.md You can return any text - it will be passed to next loop iteration - but You should use Handoff file for structured data handling between sessions**
**If You are sure the FILL project is completed, and You wrote `complete` to RALPH.md then You can output only "COMPLETE" as a text - loop iterations will be stopped**
