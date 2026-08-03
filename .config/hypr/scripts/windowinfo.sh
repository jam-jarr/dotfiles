#!/bin/bash

set -o errexit
set -o pipefail

info=$(hyprctl activewindow)

notify-send --transient "$info"
wl-copy <<<"$info"
