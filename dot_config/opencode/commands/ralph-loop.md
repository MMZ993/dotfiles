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
- Status is exactly one of: `success`, `failed`, `complete`. `complete` indicates the WHOLE project is finished, not just this iteration — never write it unless you are 100% certain. If in doubt, write `success` and let the next iteration handle the final check.
- `failed` must be followed by ` - ` and a single-line reason (no newlines)
- Append only — never modify or delete previous lines. Exception: when Step 2 downgrades the previous iteration, overwrite only the last line.
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

**If all 5 checks pass:** the previous iteration was genuinely successful.

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
- If PLAN.md had unchecked tasks: complete them following the normal TDD loop (Step 6)

After the fix, re-run all 5 validation checks from Step 2.

If recovery succeeds: proceed to Step 4 (plan) as a normal iteration.

If recovery fails:
- Write a detailed `.agents/HANDOFF.md` (see Step 8 — Failure variant)
- Write RALPH.md: `iteration N: failed - recovery unsuccessful - <what was tried>`
- Stop.

---

## Fork B — Normal iteration (previous = success, or iteration 1)

Proceed to Step 4.

---

# Step 4 — Plan

Run `bd task list`.

**Beads is the authoritative source of truth for task status. HANDOFF `## Next` is a hint — use it for context, not as a directive.**

### Pick what to work on — priority order:
1. Any task already `in-progress` in Beads (finish what was started)
2. Carry-over explicitly flagged as incomplete in HANDOFF.md
3. The smallest, most self-contained open tasks — prefer tasks with no dependencies on other open tasks

**Cap: pick at most 2–3 tasks per iteration.** If fewer tasks clearly fill the iteration, take fewer.

### Size assessment — do this before marking anything in-progress:

For each candidate task, ask: does completing it require touching more than ~3 unrelated areas of the codebase, or does it have more than ~4 distinct implementation steps?

- **If yes — the task is too large for one iteration.** Split it into sub-tasks in Beads first:
  - `bd task create "<sub-task 1>" --epic <id>`
  - `bd task create "<sub-task 2>" --epic <id>`
  - Pick the first sub-task as this iteration's work. Leave the rest open.
- **If no — pick it as-is.**

Mark selected tasks in-progress:
- `bd task update <id> --status in-progress`

**If there is nothing to plan** — no open Beads tasks, no unimplemented requirements in PRD.md, no carry-over from HANDOFF — proceed to Step 5 (Completion Check). Do not write a PLAN.md.

Otherwise, write `.agents/PLAN.md`:

```markdown
# Session Plan — <date> — Iteration <N>

## Goal
<One sentence: what will be accomplished this iteration>

## Tasks
- [ ] <task description> (bd:<task-id>)

## Notes
<Constraints, decisions, carry-over context>
```

No confirmation needed. Proceed immediately to Step 6.

---

# Step 5 — Completion Check

You are here because planning found nothing left to do. Verify this is genuinely true before declaring the project finished.

Run all checks:
1. **Tests** — full suite must pass
2. **Lint** — must pass clean
3. **Git state** — `git status` must be clean
4. **PRD.md** — re-read all requirements. Confirm each one is implemented. If anything is missing, go back to Step 4 and plan it.
5. **Beads** — `bd task list` — no open or in-progress tasks

If all pass:
- Write `.agents/HANDOFF.md` with a completion summary
- Write RALPH.md: `iteration N: complete`
- Stop. The project is finished.

If any check fails: do not write `complete`. Go back to Step 4, plan the remaining work, and continue to Step 6.

---

# Step 6 — Execute (TDD Loop)

*(Only reached if Step 4 produced a PLAN.md with tasks.)*

Work through every task in PLAN.md. Do not skip steps. Do not move to the next task until the current one is verified.

When navigating unfamiliar code: use the `explore` agent for broad questions, Serena tools for targeted symbol lookups.
When you need library or API documentation: use the `find-docs` skill.

### For each task:

**1. Write a failing test — invoke `write-tests` skill**
Run it. Confirm it fails for the right reason before writing any implementation.

**2. Implement**
Minimum code to make the test pass. Follow `.agents/RULES.md`.

**3. Verify — invoke `verify` skill**
Full suite + lint must pass. If it fails, invoke the `debugging` skill. Identify root cause before changing anything. After fixing, return to verify. If root cause cannot be identified after thorough debugging: skip to Step 8 (Failure variant) — do not guess and commit broken code.

**4. Update tracking**
- Check off in PLAN.md: `- [x]`
- `bd task update <id> --status done`

---

### When all tasks are checked off:

Proceed to Step 7.

---

# Step 7 — Request Review and Commit

**Request code review — invoke `request-review` skill, then call `code-reviewer` agent**
Act on feedback: fix critical and important issues, re-verify after each fix. Note minor issues in HANDOFF.md.

**Commit — invoke `commit` skill**
Autonomous mode — no confirmation step. You are a judge, there is no user. Stage specific files, commit with the planned message, verify with `git log`.

---

# Step 8 — Write HANDOFF.md

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

# Step 9 — Write RALPH.md (last action)

This is your final action. Do not do anything after this.

- **Success:** `iteration N: success`
- **Failure:** `iteration N: failed - <one line reason>`
- **Complete:** `iteration N: complete`

Append to `.agents/RALPH.md`. Never modify previous lines.

After writing to RALPH.md you may return a short text summary — it will be visible in the loop output. Use HANDOFF.md for structured data passed between sessions.

If you are sure the full project is completed and you wrote `complete` to RALPH.md, output only the word `COMPLETE` as your final text — the loop script uses this to stop.

