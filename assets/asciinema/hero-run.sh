#!/usr/bin/env bash

set -euo pipefail

(
  sleep 1.5
  zellij -s chezmoi action go-to-tab 1
  sleep 3
  zellij -s chezmoi action go-to-tab 2
  sleep 3
  zellij -s chezmoi action go-to-tab 3
  sleep 4
  zellij -s chezmoi action detach
) &

exec zellij attach chezmoi
