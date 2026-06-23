#!/bin/bash
set -euxo pipefail
{
  FILE="$1"
  MIME=$(file --brief --mime-type "$FILE")
  OPENERS=$(handlr list | rg "$MIME" | awk '{print $2}' | uniq)

  # Pick one with fzf and run it
  SELECTED=$(echo "$OPENERS" | fzf --prompt="Open $FILE with: ")
  [ -n "$SELECTED" ] && gtk-launch "$SELECTED" "$FILE"
} &>/tmp/open-with.log

# '''
#     { # 1. Extract ONLY the mimetype (the last word of the output)
#     MIME=$(file --brief --mime-type "$1")
#
#     # 2. Get the list of handlers for that specific MIME
#     # We clean the output to get just the .desktop names
#     LIST=$(handlr list | grep "$MIME" | grep ".desktop" | sed 's/ (default)//' | awk '{$1=$1;print}')
#
#     # 3. If handlr doesn't have specific apps, fallback to system-wide search
#     if [ -z "$LIST" ]; then
#         LIST=$(grep -l "$MIME" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | xargs -I{} basename {})
#     fi
#
#     # 4. Show the picker
#     SELECTED=$(echo "$LIST" | fzf --height=40% --reverse --header="Open with:")
#
#     echo "$SELECTED"
#
#     # 5. Launch
#     "$SELECTED" && handlr launch "$MIME" --name "$SELECTED" -- "$1"
#     } > /tmp/handlr.log 2>&1
# '''
