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
| `assets/demo/repo-tour.gif` | GitHub-friendly inline hero animation |
| `assets/demo/repo-tour.webm` | rendered hero video |
| `assets/demo/repo-tour.png` | screenshot captured from the hero tape |
| `assets/demo/bootstrap.gif` | GitHub-friendly inline supporting animation |
| `assets/demo/bootstrap.webm` | supporting demo video |

## Render The Assets

From the repo root:

```bash
vhs assets/vhs/repo-tour.tape
vhs assets/vhs/bootstrap.tape
ffmpeg -y -i assets/demo/repo-tour.webm -vf "fps=15,scale=1200:-1:flags=lanczos,palettegen" assets/demo/repo-tour-palette.png
ffmpeg -y -i assets/demo/repo-tour.webm -i assets/demo/repo-tour-palette.png -lavfi "fps=15,scale=1200:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" assets/demo/repo-tour.gif
ffmpeg -y -i assets/demo/bootstrap.webm -vf "fps=15,scale=1200:-1:flags=lanczos,palettegen" assets/demo/bootstrap-palette.png
ffmpeg -y -i assets/demo/bootstrap.webm -i assets/demo/bootstrap-palette.png -lavfi "fps=15,scale=1200:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" assets/demo/bootstrap.gif
rm assets/demo/repo-tour-palette.png assets/demo/bootstrap-palette.png
```

## Recording Principles

- use the real repo content where it is already public and safe
- never show decrypted secrets or tokens
- keep file-path presentation sanitized through hidden tape setup commands
- favor short recordings with a strong first and last frame

## Updating The README Preview

The root `README.md` is designed to use:

- `assets/demo/repo-tour.gif` as the inline hero animation on GitHub
- `assets/demo/bootstrap.gif` as the inline supporting animation on GitHub
- `assets/demo/*.webm` as smaller downloadable versions
