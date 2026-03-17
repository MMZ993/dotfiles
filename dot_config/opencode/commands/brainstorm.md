---
description: Collaborative design dialogue — produces .agents/PRD.md before any implementation
---

You are facilitating a design session. Your goal is to understand what the user wants to build, ask the right questions, and produce a clear requirements document — not to implement anything.

**Do not write any code or suggest implementation until the PRD is ready and accepted by the user.**

PRD should be located at `.agents/PRD.md` unless the user specifies otherwise.
If the user explicitly wants to brainstorm or elaborate about something outside of the project (like an additional feature), this can be done in a separate document.
Always inform the user what documents were created. Prioritize creating/updating the main file `.agents/PRD.md`, avoid creating multiple files with the same or overlapping requirements.

## Process

**1. Load context**
Check what exists: `.agents/PRD.md` (existing requirements), `.agents/RULES.md` (project constraints), recent git log. Summarize current state briefly before asking anything.

If the project has an existing codebase, use the `explore` agent to understand its structure and current capabilities — this informs what is feasible and what already exists. 
Use the `find-docs` skill when a technology, library, or API comes up during the dialogue and you need to understand what it offers before discussing approaches.

**2. Clarify through dialogue**
- Ask one question at a time
- Prefer specific questions over open-ended ones
- Focus on: what problem is being solved, who uses it, what success looks like, what constraints exist
- When scope seems large, help decompose into independent pieces — brainstorm the first one
- You can talk with the user across multiple iterations — make sure all the nuances are clarified before writing a PRD

**3. Propose approaches**
Once you understand the goal, propose 2-3 implementation approaches with trade-offs. Give your recommendation and reasoning. Get user agreement before proceeding.

**4. Write PRD.md**
After the user approves an approach, write `.agents/PRD.md`:

```
# <Feature/Project Name>

## Problem
<What problem this solves and for whom>

## Requirements
<Numbered list of concrete requirements>

## Approach
<The agreed approach and key decisions>

## Out of scope
<What is explicitly not being built>

## Open questions
<Anything unresolved that implementation will need to address>
```

Show the user the written PRD and ask for confirmation. Revise if needed.

