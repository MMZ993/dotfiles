# Dotfiles

Personal dotfiles managed with chezmoi, mise, and ansible.

## Setup

```bash
# Install chezmoi
curl -fsSL https://chezmoi.io/get | sh

# Initialize
chezmoi init --source=~/projects/dotfiles https://github.com/MMZ993/dotfiles

# Apply
chezmoi apply --source=~/projects/dotfiles
```

## Tools

- **chezmoi** - Dotfile management
- **mise** - Dev tools versioning
- **ansible** - System configuration

## Supported Distros

- Debian/Ubuntu/Pop!_OS/Linux Mint
- Fedora/Nobara/RHEL/AlmaLinux/Rocky Linux
- Arch/Manjaro
- openSUSE

## Note

This is a personal dotfiles repo with some hardcoded paths and aliases.
