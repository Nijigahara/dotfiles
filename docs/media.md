# Media

This repo's terminal showcase is built from a real terminal session recorded with `asciinema` and rendered to a GitHub-friendly GIF with `agg`.

## Requirements

- `asciinema`
- `expect`
- `agg`

On Arch Linux:

```bash
sudo pacman -S asciinema expect
cargo install --locked --git https://github.com/asciinema/agg
```

## Files

| Path | Purpose |
| --- | --- |
| `assets/asciinema/hero.exp` | scripted interactive recording driver using the real shell and tools |
| `assets/asciinema/hero.cast` | raw asciinema capture |
| `assets/demo/hero.gif` | GitHub-friendly hero animation |

## Render The Hero Demo

From the repo root:

```bash
chmod 755 assets/asciinema/hero.exp
asciinema rec --overwrite --idle-time-limit 1.2 --window-size 120x32 --command "expect -f assets/asciinema/hero.exp" assets/asciinema/hero.cast
~/.cargo/bin/agg --font-family "UbuntuMono Nerd Font,DejaVu Sans,Noto Emoji" --font-size 20 --line-height 1.3 --theme 1a1110,f1dedc,1a1110,ff7472,9aff7f,ffe472,f29b93,76352f,ffb3ac,fff0ef,a59a99,ffa09f,b8ffa5,ffeea5,ffbeb8,ffc9c4,ffdcd9,fff9f8 assets/asciinema/hero.cast assets/demo/hero.gif
```

## What The Hero Shows

- shell startup with the real `fastfetch`
- the actual `starship` prompt
- `lazygit` in a temporary demo git repo so the UI is clean and intentional
- `zellij`
- `tmux`
- `nvim` opening the real config and theme files

## Recording Principles

- capture the real shell and tool behavior instead of a staged fake prompt
- avoid showing secrets, auth tokens, or decrypted config
- keep the sequence short and visual
- make the tooling, not `chezmoi` commands, the star of the hero demo
