---
name: verify
description: Run the test suite and interpret results, call it ALWAYS when You varifying code changes
---

## Run the full suite

Always run the full test suite, not just the test you just wrote. A passing new test with a broken existing test is not a pass.

Use the test command from `.agents/RULES.md`. If not specified, check `package.json` scripts, `Makefile`, or equivalent for the project's standard test command.

## Run the linter

After the test suite passes, run the lint command from `.agents/RULES.md`. If not specified, check `package.json` scripts, `Makefile`, or equivalent (e.g. `eslint`, `ruff`, `golangci-lint`). If no lint command exists for the project, skip this step.

Lint must pass cleanly — no new errors or warnings introduced by your changes.

If lint fails: fix the issues, then re-run both the full suite and lint before continuing.

## A clean run requires

- All tests pass
- Lint passes with no new errors or warnings
- No new warnings introduced by the test runner (check if the project treats warnings as errors)
- No skipped or pending tests that were previously passing

## If any test fails

Do not start changing code. First:
1. Read the failure output completely — error message, stack trace, file and line number
2. Identify whether it is your new code that broke it, or a pre-existing failure
3. If pre-existing: flag it to the user before proceeding — do not silently inherit broken tests
4. If your code caused it: invoke the `debugging` skill

## Before marking a task done

- Full suite passes
- The new test specifically covers the behavior from the current task
- No regressions — tests that passed before still pass
