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
