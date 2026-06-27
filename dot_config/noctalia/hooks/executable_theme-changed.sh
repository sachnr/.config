#!/usr/bin/env bash
set -euo pipefail

gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.wm.preferences 'adw-gtk3'

pkill -USR2 ghostty 2>/dev/null || true
pkill -USR1 kitty 2>/dev/null || true
pkill -USR1 nvim 2>/dev/null || true
pkill -USR2 opencode 2>/dev/null || true
