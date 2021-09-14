#!/usr/bin/env bash

# slate_full     slate_center     slate_left
# slate_right    slate_top        slate_bottom


theme="slate_full"

dir="$HOME/.config/rofi/launchers/slate"
theme="slate_center.rasi"

rofi -no-lazy-grab -show drun -modi drun -theme "$dir"/"$theme"
