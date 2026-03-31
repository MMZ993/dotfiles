---
description: TDD execution loop — works through .agents/PLAN.md tasks, then reviews and wraps up
---


## Current plan

Check if `.agents/PLAN.md` exists, if not abandon further instructions and tell the user to run `/plan` first.
Read `.agents/PLAN.md` and `.agents/HANDOFF.md` to gather context.

Read `.agents/RULES.md` to get familiar with project patterns — you need it to write coherent code. If the file does not exist, notify the user and ask whether to proceed without it.

Work through every task in PLAN.md using TDD (test driven development). Do not skip steps.
Do not move to the next task until the current one is verified.
Do not rely on your own judgment for steps that have a dedicated skill — invoke the skill explicitly.

When navigating unfamiliar code or tracing dependencies, use the `explore` agent rather than searching manually — it keeps your context clean. 
When you need library or API documentation, use the `find-docs` skill.

---

### For each task in PLAN.md:

**1. Write a failing test — invoke `write-tests` skill**
Do not write any implementation code yet. The `write-tests` skill defines how tests should be structured and what patterns this project uses. Follow it. Run the test and confirm it fails for the right reason before moving on.

**2. Implement**
Write the minimum code to make the test pass. Follow `.agents/RULES.md` conventions.

**3. Verify — invoke `verify` skill**
The `verify` skill defines how to run the test suite and interpret results. Follow it. All tests must pass — including previously passing ones — before moving on.

**4. If verification fails — invoke `debugging` skill**
Do not start changing code based on intuition. The `debugging` skill defines the root-cause investigation process. Follow it. Only propose a fix after root cause is identified. After fixing, return to step 3.

**5. Update tracking**
- Check off the task in `.agents/PLAN.md`: `- [x]`
- Update td: `td update <id> --status closed`

---

### When all tasks are checked off:

**6. Request code review — invoke `request-review` skill, then call `code-reviewer` agent**
The `request-review` skill defines how to package context for the `code-reviewer` agent. Follow it. Do not write a freeform review request — use the skill.

If the reviewer finds issues: fix them, return to step 3, then re-request review once clean.

**7. Commit — invoke `commit` skill**
The `commit` skill defines how to stage and commit changes. Follow it.

**8. Session wrapup — invoke `session-wrapup` skill**
The `session-wrapup` skill handles writing `.agents/HANDOFF.md` and closing td tasks. Follow it.

---

### Stop and ask when:
- Root cause cannot be identified after following the debugging skill
- Implementation requires a decision not covered by the PLAN.md or RULES.md
- A task is significantly larger than the plan anticipated
- The plan itself needs revision to proceed

**Do not guess. Do not push through blockers. Stop and surface the issue.**
