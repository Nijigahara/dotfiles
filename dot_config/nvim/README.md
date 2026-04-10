# Neovim Configuration

This directory contains the Neovim setup tracked by the main `chezmoi` dotfiles repo.

It is the source of truth for this machine's Neovim configuration.

## Overview

This config builds on the `NvChad` ecosystem and keeps local customizations small, readable, and theme-aware.

The goals are:

- fast daily editing
- a clean Lua layout
- a consistent visual language with the rest of the desktop
- practical plugin choices instead of a giant kitchen-sink setup

## Base And Lineage

- base framework: [`NvChad`](https://github.com/NvChad/NvChad)
- additional inspiration: [`LazyVim starter`](https://github.com/LazyVim/starter)

This config is not trying to be a universal starter for everyone. It is tuned for this workstation and is versioned here as part of the wider home-directory setup.

## Structure

| Path | Purpose |
| --- | --- |
| `init.lua` | entrypoint |
| `lua/options.lua` | editor options |
| `lua/mappings.lua` | keymaps |
| `lua/autocmds.lua` | autocommands |
| `lua/plugins/` | plugin declarations and plugin-local config |
| `lua/configs/` | focused configuration modules |
| `lua/themes/` | theme definitions |

## Theme Integration

This Neovim config is part of a larger theming workflow across the machine.

Instead of existing in isolation, it sits beside coordinated theme generation for tools like Ghostty, Zellij, Zed, and Blender. That keeps the editor aligned with the rest of the desktop rather than feeling like a separate stack.

## Notes

- This directory is managed through `chezmoi`.
- The nested `.git` directory is intentionally not tracked in the dotfiles source.
- Plugin lock state is kept so the setup stays reproducible.

## Credits

- [`NvChad`](https://github.com/NvChad/NvChad)
- [`LazyVim starter`](https://github.com/LazyVim/starter) for useful structural inspiration
