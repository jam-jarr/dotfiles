#!/bin/bash

set -o errexit
set -o pipefail

info=$(hyprctl activewindow)

notify-send "$info"
wl-copy <<<"$info"
