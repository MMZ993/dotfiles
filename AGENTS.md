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

## Reading Large Files

Before reading any file in full, check its line count first:
```
wc -l <file>
```
If the file exceeds 2000 lines, never read it all at once — use `offset` and `limit` to read it in chunks of at most 2000 lines. The bash tool may silently truncate output beyond 2000 lines.

## Configuration File Paths

- **Mise config**: `dot_config/mise/config.toml.tmpl`

---

## Documentation Updates

When editing configuration files that change the installed software or system setup, **ALWAYS** update SETUP.md to keep it in sync:
- Add new tools/packages to the appropriate sections
- Update installation order if adding new installation steps
- Keep mise_tools, ansible_system_packages, chezmoi_scripts, etc. aligned with actual configs
