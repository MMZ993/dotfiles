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
- **opencode** - AI coding agent with custom agent workflow (see [`dot_config/opencode/README.md`](dot_config/opencode/README.md))

## Supported Distros

- Debian/Ubuntu/Pop!\_OS/Linux Mint
- Fedora/Nobara/RHEL/AlmaLinux/Rocky Linux
- Arch/Manjaro
- openSUSE

## Note

This is a personal dotfiles repo with some hardcoded paths and aliases.

---

# Detailed Documentation

## Chezmoi

Chezmoi is the primary dotfile management tool that orchestrates the entire setup process.

### Configuration Files

- **`.chezmoi.toml.tmpl`** - Main configuration file that prompts for git user data (email and full name) on first run
- **`.chezmoiignore`** - Excludes files from being managed by chezmoi, including:
  - Secrets: `.env_secrets`, `.bash_private`, certificates
  - Generated files and caches: `.bash_completion.d/*`, `.cache/*`, `.local/share/mise/*`
  - Lock files: `dot_config/mise/config.toml`
  - Temporary files, OS-specific files, and project-specific caches

### Managed Dotfiles

All dotfiles follow the `dot_` prefix naming convention and are managed by chezmoi:

- **Shell Configuration**
  - `.bashrc` - Main bash configuration with PATH setup, mise activation, starship prompt, fzf integration, and LS_COLORS
  - `.bash_profile` - Sources `.bashrc` for login shells
  - `.bash_functions` - Custom functions: `mkcd`, `unpack`, `bck`, `ff`, `fdir`, `grepd`, `qfind`, `duh`, `cl`, `proc`, `dataurl`, `note`, `ai`
  - `.bash_aliases` - Smart tool aliases (eza, bat, nvim), navigation shortcuts, Git/Docker aliases, system info aliases
  - `.bash_completion.d/` - Directory for custom bash completions

- **Git Configuration**
  - `.gitconfig` - Git settings with user data template, aliases (`st`, `co`, `ci`, `br`, `df`, `lg`, `last`), and rebasing behavior

- **Editor and Terminal**
  - `.config/nvim/` - LazyVim configuration (Neovim)
  - `.tmux.conf` - Tmux configuration with TokyoNight theme, vi keybindings, mouse support, and TPM plugins (tmux-sensible, tmux-resurrect, tmux-continuum, tmux-yank)
  - `.config/starship.toml` - Starship prompt configuration with directory, git branch/status, and Python venv indicators

- **Other Configurations**
  - `.gitignore_global` - Global gitignore patterns
  - `.prettierrc.json` - Prettier configuration

### Chezmoi Scripts (Orchestration)

Chezmoi runs scripts in a specific order to set up the environment:

#### Before Scripts (run before dotfile application)

1. **`run_once_before_00-install-system-packages.sh.tmpl`**
   - Installs essential system packages: `curl`, `git`, `python3`
   - Supports: Debian/Ubuntu (apt), Fedora/Nobara/RHEL (dnf), Arch (pacman), openSUSE (zypper)
   - Runs only once when needed

2. **`run_once_before_10-install-uv-ansible.sh.tmpl`**
   - Installs `uv` (Python package manager) via official install script
   - Installs `ansible-core` with `ansible` via `uv tool install`
   - Both tools installed to `~/.local/bin`
   - Runs only once when needed

3. **`run_once_before_20-install-mise.sh.tmpl`**
   - Installs `mise` (development tool version manager) via official install script
   - Installed to `~/.local/bin`
   - Runs only once when needed

#### After Scripts (run after dotfile application)

4. **`run_onchange_after_00-ansible.sh.tmpl`**
   - Runs Ansible playbook when Ansible configuration files change
   - Hash-based trigger includes: `ansible.cfg`, `site.yml`, and all role tasks/vars
   - Runs: `ansible-playbook -i localhost, site.yml -K -v -e "target_user=<username>"`
   - Requires sudo privileges (`-K` flag)

5. **`run_onchange_after_10-mise-install.sh.tmpl`**
   - Runs `mise install --yes` when `config.toml.tmpl` changes
   - Automatically installs/updates all tools defined in mise configuration
   - Non-interactive (`--yes` flag)

6. **`run_once_after_20-generate-completions.sh.tmpl`**
   - Generates bash completions for: `chezmoi`, `kubectl`, `docker`
   - Outputs completions to `~/.bash_completion.d/<tool>`
   - Runs once after initial setup

### Template Files

Several files use chezmoi templates for dynamic content:

- `.chezmoi.toml.tmpl` - Prompts for email and name
- `.gitconfig.tmpl` - Uses email and name from chezmoi data
- `.bash_completion.d/terraform.tmpl` - Conditionally includes terraform completion if installed via mise

---

## Mise

Mise (formerly rtx) is a development tool version manager that handles multiple runtime versions and CLI tools.

### Configuration

- **Location**: `~/.config/mise/config.toml` (generated from `dot_config/mise/config.toml.tmpl`)
- **Template**: Uses chezmoi template for flexible configuration

### Managed Tools

Tools are organized into categories:

#### Core Development

- `python` - Latest Python version
- `uv` - Latest UV (Python package/installer)
- `node` - LTS Node.js version
- `neovim` - Latest Neovim
- `tmux` - Latest tmux
- `starship` - Latest Starship prompt
- `vivid` - Latest LS_COLORS generator

#### CLI Tools

- `eza` - Modern `ls` replacement with icons
- `bat` - `cat` clone with syntax highlighting
- `fzf` - Fuzzy finder
- `ripgrep` - Fast grep alternative
- `fd` - Fast `find` alternative
- `zoxide` - Smart `cd` alternative
- `jq` - JSON processor
- `yq` - YAML processor
- `delta` - Better git diff viewer
- `pipx:llm` - LLM tool (with llm-gemini-code-assist plugin)

#### System Monitoring

- `btop` - Resource monitor
- `usage` - CPU usage analyzer
- `dust` - Disk usage analyzer
- `doggo` - DNS lookup tool
- `gping` - Ping with graph

#### Web Search

- `pipx:ddgr` - DuckDuckGo search from terminal

#### DevOps

- `terraform` - Infrastructure as Code tool
- `kubectl` - Kubernetes CLI
- `helm` - Kubernetes package manager
- `k9s` - Kubernetes TUI
- `lazygit` - Git TUI
- `pipx:ansible-lint` - Ansible linter

### Settings

- `experimental = true` - Enables experimental features
- `asdf_compat = true` - Enables asdf compatibility mode

### Installation

Mise installs tools to `~/.local/share/mise/installs/` and creates shims in `~/.local/share/mise/shims/`.

---

## Ansible

Ansible handles system-level configuration and package installation across multiple Linux distributions.

### Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── site.yml                 # Main playbook
└── roles/
    ├── common/              # Common system packages
    │   ├── tasks/main.yml   # Installation tasks
    │   └── vars/main.yml    # Package variables
    ├── docker/              # Docker installation
    │   ├── tasks/main.yml   # Docker-specific tasks
    │   └── vars/main.yml    # Docker package variables
    └── nvtop/               # NVIDIA GPU monitoring
        ├── tasks/main.yml   # NVTop tasks (conditional)
        └── vars/main.yml    # NVTop package name
```

### Main Playbook

**`site.yml`** runs roles in dependency order:

1. `common` - Base system packages
2. `nvtop` - GPU monitoring (only if NVIDIA GPU detected)
3. `docker` - Container platform

**Configuration**:

- Connection: Local (`localhost`)
- Privilege escalation: Yes (`become: true`)
- Extra vars: `target_user` passed from chezmoi

### Roles

#### Common Role

**Purpose**: Install essential system packages across all supported distributions

**Common Packages** (installed on all distros):

- `curl`, `git`, `xclip`, `wl-clipboard`, `unzip`, `nmap`, `w3m`

**Distro-Specific Packages**:

- **Debian/Ubuntu**: `build-essential`, `ca-certificates`, `gnupg`, `software-properties-common`, `xz-utils`, `netcat-openbsd`
- **Fedora/Nobara/RHEL/AlmaLinux/Rocky**: `@development-tools`, `xz`, `nmap-ncat`
- **Arch/Manjaro**: `base-devel`, `xz`, `openbsd-netcat`
- **openSUSE**: `patterns-devel-base-devel`, `xz`, `netcat`

**Task Flow**:

1. Check for NVIDIA GPU presence
2. Install packages based on OS family detection

#### Docker Role

**Purpose**: Install and configure Docker CE with user group membership

**Docker Packages** (standard distros):

- `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`

**Arch Packages** (different naming):

- `docker`, `docker-compose`

**Installation by Distro**:

**Fedora/Nobara**:

- Add Docker official repository
- Install via `dnf`

**RHEL-based (AlmaLinux/Rocky)**:

- Add Docker CE repository
- Install via `dnf`

**Debian/Ubuntu**:

- Create `/etc/apt/keyrings` directory
- Download Docker GPG key
- Add Docker repository
- Install via `apt`

**Arch**:

- Install directly via `pacman`

**openSUSE**:

- Add Virtualization:containers repository
- Refresh repositories
- Install via `zypper`

**Post-Installation**:

1. Ensure `docker` group exists
2. Add `target_user` to `docker` group (requires sudo)
3. Enable and start Docker service

#### NVTop Role

**Purpose**: Install NVIDIA GPU monitoring tool (only if NVIDIA GPU detected)

**Condition**: Runs only if `/proc/driver/nvidia/version` exists

**Package**: `nvtop` (same name across all supported distros)

**Installation**: Uses distro-specific package manager (apt, dnf, pacman, zypper)

### Ansible Configuration

**`ansible.cfg`**:

- `roles_path = roles/` - Set role path
- `gathering = smart` - Smart fact gathering
- `retry_files_enabled = false` - Disable retry files
- `display_skipped_hosts = false` - Don't show skipped hosts

---

## Chezmoi Scripts (Orchestration)

The chezmoi scripts provide a complete orchestration pipeline for setting up a development environment from scratch.

### Execution Flow

```
run_once_before_* (Preparation)
  ↓
Chezmoi applies dotfiles
  ↓
run_onchange_after_* (Configuration)
  ↓
run_once_after_* (Finalization)
```

### Pre-Application Scripts

#### 1. System Packages Installation

**File**: `run_once_before_00-install-system-packages.sh.tmpl`
**Trigger**: First time chezmoi runs
**Purpose**: Install minimal requirements for other tools
**Packages**: `curl`, `git`, `python3`
**Behavior**:

- Checks if each package is already installed
- Installs missing packages using distro-appropriate package manager
- Skips if all packages present

#### 2. UV and Ansible Installation

**File**: `run_once_before_10-install-uv-ansible.sh.tmpl`
**Trigger**: First time chezmoi runs
**Purpose**: Install package manager and configuration tool
**Behavior**:

- Ensures `~/.local/bin` exists and is in PATH
- Installs `uv` if not present (via curl script)
- Installs `ansible-core` with `ansible` via `uv tool install` if not present
- Both tools installed to `~/.local/bin`

#### 3. Mise Installation

**File**: `run_once_before_20-install-mise.sh.tmpl`
**Trigger**: First time chezmoi runs
**Purpose**: Install development tool version manager
**Behavior**:

- Ensures `~/.local/bin` exists and is in PATH
- Installs `mise` if not present (via curl script)
- Installed to `~/.local/bin`

### Post-Application Scripts

#### 4. Ansible Configuration

**File**: `run_onchange_after_00-ansible.sh.tmpl`
**Trigger**: When any Ansible file changes (hash-based)
**Monitored Files**:

- `ansible/ansible.cfg`
- `ansible/site.yml`
- `ansible/roles/*/tasks/main.yml`
- `ansible/roles/*/vars/main.yml`

**Behavior**:

- Changes to `ansible/` directory
- Runs: `ansible-playbook -i localhost, site.yml -K -v -e "target_user=<username>"`
- Requires sudo password for privilege escalation
- Skips if `ansible-playbook` not found

#### 5. Mise Tools Installation

**File**: `run_onchange_after_10-mise-install.sh.tmpl`
**Trigger**: When `dot_config/mise/config.toml.tmpl` changes (hash-based)
**Behavior**:

- Runs: `mise install --yes`
- Installs/updates all tools defined in mise configuration
- Non-interactive mode (auto-confirms)
- Skips if `mise` not found

#### 6. Completions Generation

**File**: `run_once_after_20-generate-completions.sh.tmpl`
**Trigger**: First time chezmoi applies dotfiles
**Purpose**: Generate bash completions for CLI tools
**Behavior**:

- Creates `~/.bash_completion.d/` directory
- Generates completions for: `chezmoi`, `kubectl`, `docker`
- Outputs to `~/.bash_completion.d/<tool>`
- Skips tools not installed
- Terraform completion handled by template file

### Script Characteristics

**Hash-Based Triggers**:

- `run_onchange_after_*` scripts use file hashes to detect changes
- Prevents redundant execution when files haven't changed
- Ensures configuration stays in sync with source files

**PATH Management**:

- All scripts ensure `~/.local/bin` is in PATH
- Critical for finding tools installed by earlier scripts

**Error Handling**:

- `set -e` ensures scripts exit on errors
- Prevents partial configurations

**Conditional Execution**:

- Scripts check for tool existence before attempting to use it
- Graceful degradation when tools aren't available

### Integration Points

**Chezmoi → System**:

- Scripts interact with system package managers (apt, dnf, pacman, zypper)
- Require sudo privileges for some operations

**Chezmoi → Ansible**:

- Passes username as extra-var for user group management
- Detects Ansible configuration changes

**Chezmoi → Mise**:

- Detects mise configuration changes
- Triggers tool installation/updates

**Chezmoi → Shell**:

- Generates completions loaded by `.bashrc`
- Creates shell configuration files

---

## Updates

Refer to `UPDATE.md` for detailed update commands for:

- Core tools (chezmoi, mise, uv, ansible)
- Dotfiles (chezmoi update/apply)
- System packages (via Ansible)
- Mise tools (mise install)
