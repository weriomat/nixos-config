#!/usr/bin/env bash

wallpaper_path=$HOME/.nixos/nixos/wallpapers

wallpaper_name="$(ls "$wallpaper_path" | wofi --show dmenu --sort-order=alphabetical)"
if [[ -f $wallpaper_path/$wallpaper_name ]]; then
    wall-change "$wallpaper_path"/"$wallpaper_name" &
    notify-send -u normal "Changed Wallpaper to $wallpaper_name"
else
    exit 1
fi
