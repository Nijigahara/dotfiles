# Media

This repo's terminal showcase is built from a real `zellij` session recorded with `asciinema` and rendered to a GitHub-friendly GIF with `agg`.

## Requirements

- `asciinema`
- `agg`

On Arch Linux:

```bash
sudo pacman -S asciinema
cargo install --locked --git https://github.com/asciinema/agg
```

## Files

| Path | Purpose |
| --- | --- |
| `assets/asciinema/hero-run.sh` | attaches to the `chezmoi` zellij session and advances through the showcase tabs |
| `assets/asciinema/hero.cast` | raw asciinema capture |
| `assets/demo/hero.gif` | GitHub-friendly hero animation |

## Render The Hero Demo

From the repo root:

```bash
chmod 755 assets/asciinema/hero-run.sh
asciinema rec --overwrite --idle-time-limit 1.2 --window-size 120x32 --command "bash assets/asciinema/hero-run.sh" assets/asciinema/hero.cast
~/.cargo/bin/agg --font-family "UbuntuMono Nerd Font,DejaVu Sans,Noto Emoji" --font-size 20 --line-height 1.3 --theme 1a1110,f1dedc,1a1110,ff7472,9aff7f,ffe472,f29b93,76352f,ffb3ac,fff0ef,a59a99,ffa09f,b8ffa5,ffeea5,ffbeb8,ffc9c4,ffdcd9,fff9f8 assets/asciinema/hero.cast assets/demo/hero.gif
```

## What The Hero Shows

- a named `zellij` session: `chezmoi`
- `lazygit` in the first tab
- `opencode` in the second tab
- an `editors` tab with side-by-side Neovim panes for `README.md` and `dot_config/nvim/lua/themes/dankcolors.lua`

## Recording Principles

- capture the real workspace and tool behavior instead of a staged fake prompt
- avoid showing secrets, auth tokens, or decrypted config
- keep the sequence short and visual
- make the actual terminal workspace, not `chezmoi` commands, the star of the hero demo
