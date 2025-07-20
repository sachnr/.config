#!/bin/bash

OPTIONS="⏻  Shutdown\n󰜉  Reboot\n󰗼  Logout\n  Lock"

SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/config.rasi)

case "$SELECTED" in
"⏻  Shutdown")
    systemctl poweroff
    ;;
"󰜉  Reboot")
    systemctl reboot
    ;;
"󰗼  Logout")
    hyprctl dispatch exit
    ;;
"  Lock")
    hyprlock
    ;;
esac
