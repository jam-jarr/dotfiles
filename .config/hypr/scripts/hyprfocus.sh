#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
  hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled false;\
        keyword decoration:rounding 0"
  swaync-client -dn
  hyprctl notify 1 5000 "rgb(40a02b)" "Hyprfocus [ON]"
  exit
else
  hyprctl notify 1 5000 "rgb(d20f39)" "Hyprfocus [OFF]"
  swaync-client -df
  hyprctl reload
  exit 0
fi
exit 1
