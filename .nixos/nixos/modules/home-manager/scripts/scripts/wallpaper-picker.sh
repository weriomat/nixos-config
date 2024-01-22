#!/usr/bin/env bash

# wallpaper_path=$HOME/Pictures/wallpapers
wallpaper_path=$HOME/.nixos/nixos/wallpapers

# wallpapers_folder=$HOME/Pictures/wallpapers/others
wallpaper_name="$(ls $wallpaper_path | wofi --show dmenu --sort-order=alphabetical)"
if [[ -f $wallpaper_path/$wallpaper_name ]]; then
    # swaybg -m fill -i $wallpaper_path/$wallpaper_name &
    wall-change $wallpaper_path/$wallpaper_name &
    notify-send -u normal "Changed Wallpaper to $wallpaper_name"
    # find $HOME/.nixos/nixos/wallpapers -maxdepth 1 -type f -delete
    # cp $wallpaper_path/$wallpaper_name $wallpaper_path/$wallpaper_name
    # wall-change $wallpaper_path/$wallpaper_name
    # swaybg -i $wallpaper_path/$wallpaper_name
else
    exit 1
fi
