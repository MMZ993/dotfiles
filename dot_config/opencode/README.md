# Agent Workflow

Spec-driven, TDD development workflow for opencode. Built around a persistent project backlog, session-scoped plans, and a clear separation between design, planning, and execution.

---

## How it works

### Project files

All project context lives in `.agents/` at the repo root:

| File | Created by | Purpose |
|---|---|---|
| `.agents/PRD.md` | `/brainstorm` or user | Product requirements — source of truth |
| `.agents/RULES.md` | `/prepare-rules` or `/survey-codebase` | Project-specific conventions, libraries, exact versions |
| `.agents/PLAN.md` | `/plan` | Current session task list — ephemeral |
| `.agents/HANDOFF.md` | `session-wrapup` skill | Handoff context for the next session |
| `AGENTS.md` | User | Project scope extension for the build agent |

### Workflows

**New project:**
```
/brainstorm → .agents/PRD.md
/prepare-rules → .agents/RULES.md
/plan → .agents/PLAN.md + beads tasks
/dev → TDD loop → review → commit → session-wrapup
```

**Existing / cloned project:**
```
/survey-codebase → .agents/RULES.md
/plan → .agents/PLAN.md + beads tasks
/dev → TDD loop → review → commit → session-wrapup
```

**Resuming a session:**
```
/plan (reads HANDOFF.md automatically) → /dev
```

**Quick fix or small isolated change:**
```
/quickfix → TDD loop → review → commit
```
No planning ritual, no beads tracking (unless a task ID is provided). Use when the change is too small to warrant a full session.

### The `/dev` loop

```
For each task in PLAN.md:
  write-tests skill → failing test
  implement → pass the test
  verify skill → full suite passes
  if fails → debugging skill → fix → verify again
  check off task + update beads

When all done:
  request-review skill → code-reviewer agent
  commit skill
  session-wrapup skill → HANDOFF.md + close beads tasks
```

---

## Agents

| Agent | Mode | Purpose |
|---|---|---|
| `build` | primary | Main coding agent. TDD, Serena navigation, reads project context on start |
| `devops` | primary | Infrastructure and DevOps agent — Ansible, Terraform, Kubernetes, GitLab CI/CD, Linux, networking. Safety-first, no commands without explicit permission |
| `ask` | primary | Quick Q&A — direct answers without burning build context |
| `explore` | subagent | Read-only codebase exploration via AiDex and CBM. Use for finding files, tracing dependencies, understanding architecture |
| `code-reviewer` | subagent | Fresh-context code review. Invoked via `request-review` skill after plan completion |

---

## Commands

User-invoked slash commands. Not called autonomously by the agent.

| Command | Purpose |
|---|---|
| `/brainstorm` | Design dialogue → produces `.agents/PRD.md` |
| `/prepare-rules` | Generates `.agents/RULES.md` from PRD — for new projects |
| `/survey-codebase` | Generates `.agents/RULES.md` from existing code — for cloned/existing projects |
| `/plan` | Creates `.agents/PLAN.md` and syncs beads tasks for the session |
| `/dev` | Executes the TDD loop through PLAN.md |
| `/quickfix` | TDD loop for a single fix or small change — no planning ritual, no session wrapup |

---

## Skills

Invoked by the agent at specific points in the workflow. Can also be run manually.

| Skill | Invoked when |
|---|---|
| `write-tests` | Before any implementation — writes the failing test |
| `verify` | After implementation — runs full test suite |
| `debugging` | When verify fails — finds root cause before any fix |
| `request-review` | After all PLAN.md tasks done — packages context for code-reviewer |
| `commit` | After review passes — conventional commits, atomic |
| `session-wrapup` | End of session — HANDOFF.md, closes beads tasks |
| `find-docs` | On demand — looks up library docs and verifies versions via Context7 |

---

## Required tools

### MCP servers

| MCP | Used by | Purpose |
|---|---|---|
| **Serena** | `build` agent only | Symbol-level code navigation and editing (LSP-backed). Globally denied, explicitly allowed for build. Repo: https://github.com/oraios/serena |
| **AiDex** (`aidex`) | `explore` agent | File-level code index — signatures, identifiers, file tree, project summary. Restricted to explore agent. Repo: https://github.com/cscsoftware/aidex |
| **CBM** (`cbm`) | `explore` agent | Code knowledge graph — architecture overview, symbol search, call path tracing, graph queries. Restricted to explore agent. Repo: https://github.com/DeusData/codebase-memory-mcp |

### CLI tools

| Tool | Command | Purpose |
|---|---|---|
| **Beads** | `bd` | Persistent project backlog — epics and tasks across sessions |
| **Context7** | `ctx7` | Up-to-date library documentation and version lookup |
| **git** | `git` | Version control — diffs, commits, history |

### Plugins

| Plugin | Purpose |
|---|---|
| `cc-safety-net` | PreToolUse hook that intercepts and blocks destructive commands before execution — `rm -rf`, dangerous git ops (force push, hard reset), shell evasion attempts. Repo: https://github.com/kenryu42/claude-code-safety-net |
| `@tarquinen/opencode-dcp` | Auto-reduces token usage in long sessions via compression, deduplication, and error pruning. Repo: https://github.com/Opencode-DCP/opencode-dynamic-context-pruning |

### Serena context

Serena runs with a custom context (`opencode`) defined in `serena-context.yml`. It exposes only pure LSP semantic tools — file operations and edits are handled by opencode's native tools. Deploy to `~/.serena/contexts/opencode.yml`.

---

## Permissions model

All MCP tools are denied globally. Each agent explicitly allows only what it needs:

- `serena_*` — denied globally, build agent has full access
- `aidex_*` — denied globally, explore agent re-enables
- `cbm_*` — denied globally, explore agent re-enables

This prevents agents from accidentally using tools outside their role.

