---
name: write-tests
description: TDD test writing, call it ALWAYS before writing any tests
---

Write the test before any implementation code. The test defines the contract — what the code must do, not how.

## One test at a time

Write one failing test for the current task. Do not write multiple tests upfront. The cycle is: failing test → implement → pass → next test.

## What makes a good test

- Tests behavior, not implementation details
- Has a clear, descriptive name that reads as documentation: `should return error when input is empty`, `calculates total including tax`
- Has one clear assertion (or a small group asserting a single outcome)
- Is independent — does not rely on other tests or shared mutable state
- Fast — no unnecessary I/O, no sleeps
- NEVER skip test with assert=true, or comment #TODO; all tests have to be a real working tests

## Where tests live

Follow the project's existing test structure from `.agents/RULES.md`. If no convention is established:
- Co-locate test files next to source files (`foo.test.ts` next to `foo.ts`)
- Or use a `tests/` directory mirroring the source structure

## Confirm the test fails correctly

After writing the test, run it. Before moving to implementation, verify:
1. The test fails — if it passes without implementation, it tests nothing
2. It fails for the right reason — the error message should describe the missing behavior, not a syntax error or import problem

Fix any test infrastructure issues before implementing.
