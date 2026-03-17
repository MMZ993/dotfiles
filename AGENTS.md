# Dotfiles Project

This is a personal dotfiles repository managed by chezmoi for system configuration.

## Installation Requests

When user asks to "install" something, they mean:
- Add the package/tool to appropriate config file (mise, ansible, etc.)
- DO NOT actually install the package
- DO NOT run chezmoi apply

## Important Rules

- **NEVER** run `chezmoi apply` or `chezmoi edit` commands
- Always ask user to run `chezmoi apply` themselves after making config changes
- This project uses chezmoi for dotfile management

## Configuration File Paths

- **Mise config**: `dot_config/mise/config.toml.tmpl`

## OpenCode Workflow

This repo ships a full opencode agent workflow in `dot_config/opencode/`. See [`dot_config/opencode/README.md`](dot_config/opencode/README.md) for:

- Agents (`build`, `ask`, `explore`, `code-reviewer`) and their roles
- Slash commands (`/brainstorm`, `/plan`, `/dev`, etc.)
- Skills (`write-tests`, `verify`, `debugging`, `commit`, `session-wrapup`, etc.)
- Required MCP servers (Serena, AiDex, CBM) and CLI tools (Beads, Context7)
- Permissions model (all MCP denied globally, per-agent allowlists)

---

## Documentation Updates

When editing configuration files that change the installed software or system setup, **ALWAYS** update SETUP.md to keep it in sync:
- Add new tools/packages to the appropriate sections
- Update installation order if adding new installation steps
- Keep mise_tools, ansible_system_packages, chezmoi_scripts, etc. aligned with actual configs
