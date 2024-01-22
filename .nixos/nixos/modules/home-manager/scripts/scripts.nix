{ pkgs, ... }: {
  wall-change = pkgs.writeShellApplication {
    name = "wall-change";
    runtimeInputs = with pkgs; [ swaybg ];
    text = ''
      swaybg -m fill -i "$1"
    '';
  };
  wallpaper-picker = pkgs.writeShellApplication {
    name = "wallpaper-picker";
    runtimeInputs = with pkgs; [ libnotify swaybg wofi coreutils findutils ];
    text = ''
      #!/usr/bin/env bash

      wallpaper_path=$HOME/.nixos/nixos/wallpapers

      wallpaper_name="$(find "$wallpaper_path" -type f -exec basename {} \; | wofi --show dmenu --sort-order=alphabetical)"
      # w_name="$(echo "$wallpaper_name" | xargs basename)"
      if [[ -f $wallpaper_path/$wallpaper_name ]]; then
          wall-change "$wallpaper_path"/"$wallpaper_name" &
          notify-send -u normal "Changed Wallpaper to $wallpaper_name" &
      else
          exit 1
      fi
    '';
  };
  wallpaper-random = pkgs.writeShellApplication {
    name = "wallpaper-random";
    runtimeInputs = with pkgs; [ swaybg libnotify coreutils findutils ];
    text = ''
      #!/usr/bin/env bash

      wallpaper_name="$(find "$HOME"/.nixos/nixos/wallpapers -type f | shuf -n 1)"
      w_name="$(echo "$wallpaper_name" | xargs basename)"
      if [[ -f $wallpaper_name ]]; then
          wall-change "$wallpaper_name" &
          notify-send -u normal "Changed Wallpaper to $w_name" &
      else
          exit 1
      fi
    '';
  };
}
