---
installed_software:
  # Installation flow (chezmoi hooks)
  installation_order:
    - chezmoi_base_packages (curl, git, python3, native build tools) via system package manager
    - uv via curl script
    - ansible via uv (needs python3 from step 1)
    - mise via curl script
    - gh via curl script
    - ansible_system_packages (docker, nvtop, etc.) via ansible playbook
    - mise_tools via mise install

  # Via chezmoi scripts (run BEFORE ansible)
  chezmoi_base_packages:
    common_commands:
      - curl
      - git
      - python3
      - make
      - g++
    debian/ubuntu_packages:
      - curl
      - git
      - python3
      - make
      - g++
    fedora/nobara/rhel_packages:
      - curl
      - git
      - python3
      - make
      - gcc-c++
    arch_packages:
      - curl
      - git
      - python3
      - make
      - gcc
    opensuse_packages:
      - curl
      - git
      - python3
      - make
      - gcc-c++

  # Via chezmoi scripts
  chezmoi_scripts:
    - name: uv
      install: curl https://astral.sh/uv/install.sh | sh
    - name: ansible
      install: uv tool install ansible-core --with ansible
      purpose: Runs system configuration playbooks
    - name: mise
      install: curl https://mise.run | sh
    - name: gh
      install: curl script to install GitHub CLI from releases

  # Via ansible playbooks (run after ansible is installed)
  ansible_system_packages:
    common:
      - xclip
      - wl-clipboard
      - unzip
      - nmap
    debian/ubuntu:
      - build-essential
      - ca-certificates
      - gnupg
      - software-properties-common
      - xz-utils
      - netcat-openbsd
      - nfs-common
    fedora/nobara/rhel:
      - @development-tools
      - xz
      - nmap-ncat
      - nfs-utils
    arch:
      - base-devel
      - xz
      - openbsd-netcat
      - nfs-utils
    opensuse:
      - patterns-devel-base-devel
      - xz
      - netcat
      - nfs-client
    docker:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin
    nvidia_gpu:
      - nvtop (conditional, only if NVIDIA GPU detected)

  # Via mise (version manager)
  mise_tools:
    core:
      - name: python
        version: latest
      - name: uv
        version: latest
      - name: node
        version: lts
      - name: bun
        version: latest
      - name: go
        version: latest
      - name: neovim
        version: latest
      - name: tmux
        version: latest
      - name: starship
        version: latest
      - name: vivid
        version: latest
      - name: prettier
        version: latest
        install_via: npm
        note: Used by neovim conform.nvim for formatting
    cli_tools:
      - name: eza
        version: latest
      - name: bat
        version: latest
      - name: fzf
        version: latest
      - name: ripgrep
        version: latest
      - name: fd
        version: latest
      - name: zoxide
        version: latest
      - name: jq
        version: latest
      - name: yq
        version: latest
      - name: delta
        version: latest
      - name: ddgr
        version: latest
        install_via: pipx
      - name: mcporter
        version: latest
        install_via: npm
    coding_agents_utils:
      - name: pi
        version: latest
        install_via: mise (npm:@earendil-works/pi-coding-agent)
        note: Terminal-based AI coding agent
      - name: td
        version: latest
        install_via: mise (github:marcus/td)
        note: Local task tracker for AI coding sessions
      - name: ctx7
        version: latest
        install_via: npm
      - name: firecrawl-cli
        version: latest
        install_via: npm
      - name: tokscale
        version: latest
        install_via: npm
        note: Token usage tracker for AI coding assistants
      - name: agent-browser
        version: latest
        install_via: npm
        note: Browser automation CLI for AI agents. Run `agent-browser install` after mise install to download Chrome for Testing.
    monitoring:
      - name: btop
        version: latest
      - name: usage
        version: latest
      - name: dust
        version: latest
      - name: doggo
        version: latest
      - name: gping
        version: latest
    devops:
      - name: terraform
        version: latest
      - name: vault
        version: latest
      - name: kubectl
        version: latest
      - name: helm
        version: latest
      - name: k9s
        version: latest
      - name: lazygit
        version: latest
      - name: glab
        version: latest
      - name: gcx
        version: latest
        install_via: mise (github:grafana/gcx)
      - name: logcli
        version: latest
        install_via: mise (loki-logcli / aqua:grafana/loki/logcli)
        note: "latest" verified to resolve to the logcli release (not operator/v*) with mise 2026.2.8
      - name: ansible-lint
        version: latest
        install_via: pipx
      - name: hugo
        version: 0.164.0
        install_via: mise (aqua:gohugoio/hugo, standard edition)
        note: Pinned to match blog CI (.gitlab-ci.yml HUGO_VERSION); use standard edition, not extended
      - name: pre-commit
        version: latest
        install_via: pipx

  # Tmux plugins via TPM
  tmux_plugins:
    - tmux-plugins/tpm
    - tmux-plugins/tmux-sensible
    - tmux-plugins/tmux-resurrect
    - tmux-plugins/tmux-continuum (restore: on, nvim strategy: session)
    - tmux-plugins/tmux-yank

  # Neovim plugins via lazy.nvim
  neovim_plugins:
    - LazyVim/LazyVim
    - LazyVim/LazyVim (python extra)
    - LazyVim/LazyVim (json extra)
    - LazyVim/LazyVim (yaml extra)
    - LazyVim/LazyVim (prettier extra)
    - nvim-telescope/telescope-fzf-native.nvim
    - kdheepak/lazygit.nvim
    - sindrets/diffview.nvim
    - folke/zen-mode.nvim
    - nvim-lua/plenary.nvim

  # Dotfile management
  dotfile_manager:
    - name: chezmoi
      purpose: Dotfile synchronization

configs:
  git:
    global_excludes: ~/.gitignore_global
    pull_rebase: true
    rebase_autostash: true
    default_branch: main
    column_ui: auto
    branch_sort: -committerdate
    help_autocorrect: prompt
    aliases:
      st: status
      co: checkout
      ci: commit
      br: branch
      df: diff
      lg: log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
      last: log -1 HEAD

  konsole:
    default_profile: TokyoNight
    color_scheme: Tokyo Night
    background: "#1a1b26"
    foreground: "#c0caf5"

  tmux:
    general:
      default_terminal: screen-256color
      true_color: enabled
      mouse: on
      escape_time: 10ms
      focus_events: on
      extended_keys: on
      history_limit: 50000
      base_index: 1
      pane_base_index: 1
      renumber_windows: on
    keybindings:
      prefix+: Reload config
      |: Split horizontal (current path)
      -: Split vertical (current path)
      Alt-Left/Right/Up/Down: Switch panes
      Alt-h/j/k/l: Switch panes (vim-style)
      Alt-1-9: Switch windows
      Ctrl-Space: Copy mode
      Ctrl-y: Paste buffer
      Prefix + Arrows: Resize panes (repeatable)
    status_bar:
      position: top
      interval: 1s
      format: Time | Date
      window_style: TokyoNight theme

  starship:
    format: "$hostname$username$python$directory$git_branch$git_status$character"
    directory:
      style: blue
      truncation_length: 3
      truncate_to_repo: true
    git_branch:
      format: "[$symbol$branch]($style) "
      style: green
      symbol: git:
    git_status:
      style: red
      ahead: "⇡"
      behind: "⇣"
      diverged: "⇕"
      modified: "!"
      staged: "+"
      untracked: "?"
    character:
      success: "\\$" (green)
      error: "\\$" (red)
    hostname:
      ssh_only: true
      format: "DEV " (cyan)
    username:
      show_always: false
    python:
      symbol: "(v)"
      detect_files: ['.python-version']
      style: yellow

  prettier:
    semi: true
    single_quote: false
    tab_width: 2
    trailing_comma: es5
    print_width: 100
    ignore:
      - "*.md" (prettier breaks YAML frontmatter in markdown files)

  pi:
    config: dot_pi/agent/settings.json
    append_system_prompt: dot_pi/agent/APPEND_SYSTEM.md
    packages:
      - pi-effort 0.0.5 (npm package, pinned)
      - pi-config 1.0 (GitLab package: gitlab.mmz.sh/mmz-personal/pi-config; prompts, skills, and safety-net extension)

  neovim:
    base: LazyVim
    options:
      relativenumber: false
      scrolloff: 8
      sidescrolloff: 8
      spell: true
      autoformat: false (format manually with :LazyFormat or <leader>cf)
    theme: tokyonight

  mise:
    experimental: true
    asdf_compat: true

bashrc:
  env_vars:
    EDITOR: nvim
    VISUAL: nvim
    PAGER: less
    LESS: "-RiN"
    DISABLE_PROMPT_COLOR: 1 (ddgr fix)
    FIRECRAWL_NO_TELEMETRY: 1 (disable firecrawl-cli telemetry)
    HISTSIZE: 10000
    HISTFILESIZE: 20000
    HISTTIMEFORMAT: "%F %T "
    FZF_DEFAULT_OPTS: TokyoNight color scheme
    LS_COLORS: TokyoNight theme (via vivid or fallback)
    PATH: "$HOME/.local/bin", "$HOME/.local/cli/bin", "$HOME/bin", "$HOME/.scripts"
    LESS_TERMCAP_* variables for man page colors

  shell_options:
    - cdspell
    - dirspell
    - checkwinsize
    - globstar
    - extglob
    - histappend
    - cmdhist
    - histverify
    - huponexit

  functions:
    mkcd: mkdir -p "$1" && cd "$1"
    unpack: Extracts archives (tar, zip, rar, 7z, etc.)
    bck: cp "$1" "$1.backup"
    ff: Find files (uses fd if available)
    fdir: Find directories (uses fd if available)
    grepd: Recursive grep (uses ripgrep if available)
    qfind: Quick search with line numbers
    duh: Disk usage by directory (sorted)
    cl: cd "${dir:-$HOME}" && ls
    proc: Find/manage processes by name
    dataurl: Create data URL from file
    note: Quick notes in ~/projects/notes/fleeting

  aliases:
    # Smart Tool Aliases
    l: eza --icons --group-directories-first
    ll: eza -lbF --git --icons
    la: eza -lbhHigmuSa --git --icons
    lt: eza --tree --icons
    v: nvim
    vi: nvim
    vim: nvim
    bat: batcat (on Debian/Ubuntu)
    # Navigation
    ..: cd ..
    ...: cd ../..
    ....: cd ../../../
    .....: cd ../../../../
    -: cd -
    # Project Shortcuts
    cdpr: cd ~/projects
    cdnote: cd ~/projects/notes
    cdlab: cd ~/projects/homelab
    cddot: cd ~/projects/dotfiles
    cdsc: cd ~/projects/scripts
    # System Info
    today: date +%d-%m-%Y
    ports: ss -tulpn
    iip: hostname -I | awk '{print $1}'
    myip: curl ifconfig.me
    free: free -m
    df: df -h
    cpu: top -o %CPU
    # Git
    gs: git status
    ga: git add
    gc: git commit -m
    gca: git commit --amend
    gp: git push
    gl: git log --oneline --graph --decorate
    gd: git diff
    gco: git checkout
    gundo: git reset --soft HEAD~1
    gunstage: git reset HEAD --
    # Docker
    d: docker
    dc: docker compose
    up: docker compose up -d
    down: docker compose down
    dps: docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    dimg: docker images
    # Common Commands
    h: history
    hgrep: history | fzf
    j: jobs -l
    path: echo -e ${PATH//:/\\n}
    reload: source ~/.bashrc
    chx: chmod +x
    # File Operations (safe with -i)
    rm: rm -i
    cp: cp -i
    mv: mv -i
    # App Shortcuts
    t: tmux
    p: pi
    chez: chezmoi
    s: ddgr
    # DevOps
    ans: ansible
    tf: terraform
    k: kubectl
