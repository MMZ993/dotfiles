---
name: session-wrapup
description: Wraps up a coding session — documents completed work, closes td tasks, and prepares .agents/HANDOFF.md for the next session
---

# Session Wrap-Up

Properly close the session by recording what was done, updating tracking, and leaving clean context for next time.

## 1. Verify PLAN.md is fully complete

Read `.agents/PLAN.md`. Every task must be checked off (`- [x]`) before closing the session.

If any tasks are unchecked, stop and ask the user whether to complete them, carry them over to the next session, or drop them. Do not proceed with wrapup until this is resolved.

## 2. Review current session

Summarize what was accomplished:
- Features implemented
- Bugs fixed
- Tests written or updated
- Files modified or created
- Important decisions made during the session

## 3. Evaluate existing `.agents/HANDOFF.md`

If the file exists, read it and determine:
- **All work completed** — all items from the previous session were done
- **Partially completed** — some items done, others not; document why (change of plan, blocked, still relevant)
- **No longer applicable** — previous plan is obsolete; document why and what direction changed

## 4. Close td tasks

For every task completed this session:
```
td update <id> --status closed
```

For tasks not completed but still relevant, leave them open or update their description if scope changed. Use `td task list` to verify nothing was missed.

## 5. Check documentation

Review whether any documentation needs updating based on this session's changes:
- README, docs/, inline comments
- Remove or update anything no longer accurate
- Ask the user if any documentation changes need confirmation

## 6. Write `.agents/HANDOFF.md`

```markdown
# Next Session

## Previous Session Summary
<Brief description of what was done this session>

## Remaining Tasks
<Items not completed, with notes on status and why>

## Next Steps
<Specific tasks for next session, prioritized>

## Important Notes
<Context, warnings, or considerations for future work>

## Previous HANDOFF.md Review
<If previous file existed: what was done vs not done, and why>
```

## 7. Confirm

Ask the user if they want to review `.agents/HANDOFF.md` before finishing. Ensure next steps are clear and actionable.
