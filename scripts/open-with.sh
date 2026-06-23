#!/bin/bash
set -euxo pipefail
FILE="$1"
MIME=$(file --brief --mime-type "$FILE")
OPENERS=$(handlr list -a | rg -F "$MIME" | awk '{print $2}' | sed 's/,//g' | uniq)

# Pick one with fzf and run it
SELECTED=$(echo "$OPENERS" | fzf --prompt="Open $FILE with: ")
[ -n "$SELECTED" ] && gtk-launch "$SELECTED" "$FILE"
