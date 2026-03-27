#!/bin/bash

# Why is pin executed twice? pin dispatcher errors out if window is not floating
# Achieves proper toggle behavior, kinda
hyprctl dispatch pin active
hyprctl dispatch togglefloating active
hyprctl dispatch pin active
