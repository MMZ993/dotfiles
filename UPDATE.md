# Update Commands

## Update Core Tools

```bash
# Update chezmoi
chezmoi upgrade

# Update mise
mise update

# Update uv and ansible
uv self update
uv tool upgrade ansible-core --with ansible
```

## Update Dotfiles

```bash
# Pull latest changes
chezmoi update

# Apply dotfiles
chezmoi apply
```

## Update System Packages (via Ansible)

```bash
# Run ansible playbook to update system packages
cd ~/projects/dotfiles/ansible
ansible-playbook -i localhost, site.yml -K -v -e "target_user=$USER"
```

## Update Mise Tools

```bash
# Install/update tools defined in mise config.toml
mise install --yes
```
