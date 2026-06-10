#!/bin/bash
set -euo pipefail
desktopfile=$(fd . /usr/share/applications | fzf)
basename=$(basename "$desktopfile")
mimetype="$1"

# xdg-mime default imv.desktop $(rg "MimeType=" /usr/share/applications/imv.desktop | sed 's/MimeType=//' | tr ';' '\n' | rg "^image/")

xdg-mime default "$basename" $(rg "MimeType=" "$desktopfile" | sed 's/MimeType=//' | tr ';' '\n' | rg "^$mimetype")
