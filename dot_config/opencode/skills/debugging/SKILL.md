---
name: debugging
description: Systematic root-cause debugging, call it ALWAYS before any debugging attempts
---

**No fixes without root cause. Symptom fixes mask real problems and create new ones.**

## Step 1 — Read the error carefully

Do not skim. Read the full error message, stack trace, file paths, and line numbers. Error messages often contain the exact answer. Only move to investigation after reading everything.

## Step 2 — Reproduce consistently

Can you trigger the failure reliably? If not, gather more data before proceeding — do not guess at intermittent failures.

## Step 3 — Check recent changes

What changed that could have caused this? Check git diff and recent commits. New dependency, config change, refactor — the cause is usually recent.

## Step 4 — Trace the data flow

Work backward from the failure:
- Where does the bad value or wrong state come from?
- What called this with that input?
- Keep tracing up the call stack until you find the source

Fix at the source, not at the symptom.

## Step 5 — Find the pattern

Before fixing, look for similar working code in the codebase. What does the working version do differently? Compare against it.

## Step 6 — Propose the fix

Only after root cause is confirmed:
- Explain what the root cause is
- Propose a minimal fix

## When to stop and ask

If root cause cannot be identified after genuine investigation, stop and surface what you found:
- What you know
- What you tried
- Where you're stuck

Do not keep trying random fixes.
