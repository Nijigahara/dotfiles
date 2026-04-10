# Media

This repo includes reproducible terminal showcase assets generated with `VHS`.

## Requirements

- `vhs`
- `ffmpeg`
- `ttyd`

On Arch Linux:

```bash
sudo pacman -S vhs ffmpeg ttyd
```

## Files

| Path | Purpose |
| --- | --- |
| `assets/vhs/repo-tour.tape` | main showcase recording |
| `assets/vhs/bootstrap.tape` | quick restore-oriented supporting demo |
| `assets/demo/repo-tour.webm` | rendered hero video |
| `assets/demo/repo-tour.png` | screenshot captured from the hero tape |
| `assets/demo/bootstrap.webm` | supporting demo video |

## Render The Assets

From the repo root:

```bash
vhs assets/vhs/repo-tour.tape
vhs assets/vhs/bootstrap.tape
```

## Recording Principles

- use the real repo content where it is already public and safe
- never show decrypted secrets or tokens
- keep file-path presentation sanitized through hidden tape setup commands
- favor short recordings with a strong first and last frame

## Updating The README Preview

The root `README.md` is designed to use:

- `assets/demo/repo-tour.png` as the inline preview image
- `assets/demo/repo-tour.webm` as the linked hero recording
- `assets/demo/bootstrap.webm` as a supporting terminal demo
