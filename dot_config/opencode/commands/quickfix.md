---
description: TDD loop for a single focused fix or small change — no planning ritual, no session wrapup
---

## Setup

Read `.agents/RULES.md` for project conventions. If it doesn't exist, ask the user before proceeding.
Read `.agents/HANDOFF.md` if it exists — relevant context may apply.

If the user hasn't described the change yet, ask for it now — one focused question.

When navigating unfamiliar code, use the `explore` agent to keep your context clean.
When you need library or API documentation, use the `find-docs` skill.

---

## Execute the fix

**1. Write a failing test — invoke `write-tests` skill**
Do not write any implementation code yet. Run the test and confirm it fails for the right reason before moving on. If the fix doesn't lend itself to a test (e.g. config change, docs), note why and proceed without one — but be explicit about it.

**2. Implement**
Write the minimum code to make the test pass. Follow `.agents/RULES.md` conventions. Do not fix unrelated things you notice along the way — note them instead.

**3. Verify — invoke `verify` skill**
All tests must pass before moving on. If verification fails, invoke the `debugging` skill.

**4. Request code review — invoke `request-review` skill, then call `code-reviewer` agent**
Even for small changes. If the reviewer finds issues: fix, verify again, then re-request review.

**5. Commit — invoke `commit` skill**

**6. Beads (optional)**
If the user provided a beads task ID, update it: `bd task update <id> --status done`
If no ID was given, do not create one — this is a quick change, not a tracked task.

---

### Stop and ask when:
- Root cause cannot be identified
- The fix turns out to be larger than expected — surface this and suggest switching to `/plan`
- Implementation requires a decision not covered by RULES.md

**Do not guess. Do not expand scope. Stop and surface the issue.**
