{pkgs, ...}: {
  sleepidle = pkgs.writeShellApplication {
    name = "sleepidle";
    runtimeInputs = with pkgs; [hyprland swayidle swaylock libnotify];
    text = ''
      swayidle -w timeout 300 'swaylock -f -c 000000' \
                  timeout 550 'notify-send -u critical --app-name=screenlockwarning "Screen will lock in 30 seconds"' \
                  timeout 600 'hyprctl dispatch dpms off' \
                  resume 'hyprctl dispatch dpms on' \
                  timeout 900 'systemctl suspend' \
                  before-sleep 'playerctl pause' \
                  before-sleep 'swaylock -f -c 000000' &
    '';
  };

  # TODO: here
  # xdg = pkgs.writeShellApplication {
  #   name = "xdg";
  #   runtimeInputs = with pkgs; [ killall ];
  #   text = ''
  #     sleep 1

  #     # kill all possible running xdg-desktop-portals
  #     killall xdg-desktop-portal-hyprland
  #     killall xdg-desktop-portal-gnome
  #     killall xdg-desktop-portal-kde
  #     killall xdg-desktop-portal-lxqt
  #     killall xdg-desktop-portal-wlr
  #     killall xdg-desktop-portal-gtk
  #     killall xdg-desktop-portal
  #     sleep 1

  #     # start xdg-desktop-portal-hyprland
  #     /usr/lib/xdg-desktop-portal-hyprland &
  #     sleep 2

  #     # start xdg-desktop-portal
  #     /usr/lib/xdg-desktop-portal &
  #     sleep 1
  #   '';
  # };
  toggle_toggle_blur = pkgs.writeShellApplication {
    name = "toggle_blur";
    runtimeInputs = with pkgs; [hyprland];
    text = ''
        #!/usr/bin/env bash
      if hyprctl getoption decoration:blur:enabled | grep "int: 1" >/dev/null ; then
          hyprctl keyword decoration:blur:enabled false >/dev/null
      else
          hyprctl keyword decoration:blur:enabled true >/dev/null
      fi
    '';
  };
  runbg = pkgs.writeShellApplication {
    name = "runbg";
    text = ''
      #!/usr/bin/env bash

      [ $# -eq 0 ] && {  # $# is number of args
          echo "$(basename "$0"): missing command" >&2
          exit 1
      }
      prog="$(which "$1")"  # see below
      [ -z "$prog" ] && {
          echo "$(basename "$0"): unknown command: $1" >&2
          exit 1
      }
      shift  # remove $1, now $prog, from args
      tty -s && exec </dev/null      # if stdin is a terminal, redirect from null
      tty -s <&1 && exec >/dev/null  # if stdout is a terminal, redirect to null
      tty -s <&2 && exec 2>&1        # stderr to stdout (which might not be null)
      "$prog" "$@" &  # $@ is all args
    '';
  };
  lofi = pkgs.writeShellApplication {
    name = "lofi";
    runtimeInputs = with pkgs; [coreutils mpv-unwrapped mako libnotify];
    text = ''
      #!/usr/bin/env bash

      if (pgrep -fl mpv | grep -v grep > /dev/null) then
          pkill mpv
          notify-send -u normal "Stopped Lofi Stream"
      else
          runbg mpv --no-video https://www.youtube.com/live/jfKfPfyJRdk?si=OF0HKrYFFj33BzMo
          notify-send -u normal "Started Lofi Stream"
      fi
    '';
  };
  wall-change = pkgs.writeShellApplication {
    name = "wall-change";
    runtimeInputs = with pkgs; [swaybg killall];
    text = ''
      killall swaybg || true
      swaybg -m fill -i "$1"
    '';
  };
  wallpaper-picker = pkgs.writeShellApplication {
    name = "wallpaper-picker";
    runtimeInputs = with pkgs; [
      libnotify
      swaybg
      wofi
      mako
      coreutils
      findutils
      killall
    ];
    text = ''
      #!/usr/bin/env bash

      wallpaper_path=$HOME/.nixos/nixos/wallpapers

      wallpaper_name="$(find "$wallpaper_path" -type f -exec basename {} \; | wofi --show dmenu --sort-order=alphabetical)"
      if [[ -f $wallpaper_path/$wallpaper_name ]]; then
          killall dynwallpaper || true
          wall-change "$wallpaper_path"/"$wallpaper_name" &
          notify-send -u normal "Changed Wallpaper to $wallpaper_name" &
      else
          exit 1
      fi
    '';
  };
  wallpaper-random = pkgs.writeShellApplication {
    name = "wallpaper-random";
    runtimeInputs = with pkgs; [swaybg libnotify coreutils mako findutils];
    text = ''
      #!/usr/bin/env bash

      wallpaper_name="$(find "$HOME"/.nixos/nixos/wallpapers -type f | shuf -n 1)"
      w_name="$(echo "$wallpaper_name" | xargs basename)"
      if [[ -f $wallpaper_name ]]; then
          killall dynwallpaper || true
          wall-change "$wallpaper_name" &
          notify-send -u normal "Changed Wallpaper to $w_name" &
      else
          exit 1
      fi
    '';
  };

  dynwallpaper = pkgs.writeShellApplication {
    name = "dynwallpaper";
    runtimeInputs = with pkgs; [swaybg libnotify coreutils mako findutils];
    text = ''
      #!/usr/bin/env bash
      while true; do
        wallpaper_name="$(find "$HOME"/.nixos/nixos/wallpapers -type f | shuf -n 1)"
        w_name="$(echo "$wallpaper_name" | xargs basename)"
        if [[ -f $wallpaper_name ]]; then
            wall-change "$wallpaper_name" &
            notify-send -u normal "Changed Wallpaper to $w_name" &
        else
            exit 1
        fi
        sleep 108000
      done
    '';
  };
}
