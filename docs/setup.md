# Setup Guide

This document covers the intended restore path for this dotfiles repo.

## Requirements

Install at least:

- `git`
- `chezmoi`
- `gpg`

You will also need the exported GPG backup files if you want encrypted config to work immediately.

## First-Time Restore

### 1. Import the GPG keys

```bash
gpg --import ~/Documents/chezmoi-gpg-backup/chezmoi-gpg-public.asc
gpg --import ~/Documents/chezmoi-gpg-backup/chezmoi-gpg-secret.asc
```

### 2. Initialize the repo

```bash
chezmoi init https://github.com/Nijigahara/dotfiles.git
```

During init, `chezmoi` can recreate its config from `.chezmoi.toml.tmpl`.

### 3. Apply the dotfiles

```bash
chezmoi apply
```

### 4. Verify that decryption works

```bash
chezmoi status
```

If this completes without GPG decryption errors, encrypted files are available.

## Enable Daily Sync

If the timer is not already enabled on the target machine:

```bash
systemctl --user daemon-reload
systemctl --user enable --now chezmoi-auto-sync.timer
```

Check it with:

```bash
systemctl --user status chezmoi-auto-sync.timer
```

## Optional Post-Setup Tasks

Depending on the machine, you may also want to install:

- fonts referenced by Ghostty, Zed, and terminal tooling
- desktop packages used by Hyprland or Niri
- Neovim dependencies expected by the configured plugins
- OBS, Blender, and qBittorrent if you want those configs to matter

## Common Commands

Update source from local changes:

```bash
chezmoi re-add --re-encrypt
```

Apply current source state:

```bash
chezmoi apply
```

Review changes:

```bash
chezmoi diff
```

## Troubleshooting

### GPG errors when running `chezmoi`

- verify the secret key was imported
- confirm `gpg --list-secret-keys` shows the expected key
- make sure the imported key matches the recipient in `.chezmoi.toml.tmpl`

### `chezmoi apply` succeeds but tools still look broken

This repo restores configuration, not packages. Missing executables, fonts, or plugins can still leave parts of the setup incomplete.

### Auto-sync does not push

Check:

```bash
journalctl --user -u chezmoi-auto-sync.service
```

Common causes are GitHub auth problems or a remote rebase conflict.
