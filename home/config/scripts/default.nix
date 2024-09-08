{
  pkgs,
  globals,
  ...
}: let
  wallpaper_path = "${pkgs.weriomat-wallpapers}";
in {
  sleepidle = pkgs.writeShellApplication {
    name = "sleepidle";
    runtimeInputs = with pkgs; [hyprland swayidle swaylock libnotify];
    text = ''
      swayidle -w timeout 300 'swaylock -f -c 000000' \
                  timeout 550 'notify-send -u critical --app-name=screenlockwarning "Screen will lock in 30 seconds"' \
                  timeout 580 '/etc/profiles/per-user/${globals.username}/bin/swaylock -f --grace 20 --fade-in 20'\
                  timeout 600 'hyprctl dispatch dpms off' \
                  resume 'hyprctl dispatch dpms on' \
                  timeout 900 'systemctl suspend' \
                  before-sleep 'playerctl pause' \
                  before-sleep 'swaylock -f -c 000000' &
    '';
  };

  fshow = pkgs.writeShellApplication {
    name = "fshow";
    runtimeInputs = with pkgs; [sqlite coreutils fzf gnugrep gawkInteractive gnused];
    text = ''
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
          --bind "ctrl-m:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                    {}
          FZF-EOF"
    '';
  };

  fzfmenu = pkgs.writeShellApplication {
    # Stolen from https://github.com/junegunn/fzf/wiki/Examples#fzf-as-dmenu-replacement
    name = "fzfmenu";
    runtimeInputs = with pkgs; [fzf toybox kitty bash gawkInteractive];
    text = ''
      #!/usr/bin/env bash
      FZF_DEFAULT_OPTS="--height=100% --layout=reverse --border --no-sort --prompt=\"~ \" --color=dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:gray:regular,prompt:red:bold,pointer:red:bold" exec kitty --class="fzf-menu" -e bash -c "fzf-tmux -m $* < /proc/$$/fd/0 | awk 'BEGIN {ORS=\" \"} {print}' > /proc/$$/fd/1"
    '';
  };

  fb = pkgs.writeShellApplication {
    name = "fb";
    runtimeInputs = with pkgs; [buku gawkInteractive toybox sqlite];
    # TODO: fix to work with fzf menu, sqlite3: https://github.com/junegunn/fzf/wiki/Examples#buku

    text = ''
      #!/usr/bin/env bash
      # fb - buku bookmarks fzfmenu opener
      buku -p -f 4 |
          awk -F $'\t' '{
              if ($4 == "")
                  printf "%s \t\x1b[38;5;208m%s\033[0m\n", $2, $3
              else
                  printf "%s \t\x1b[38;5;124m%s \t\x1b[38;5;208m%s\033[0m\n", $2, $4, $3
          }' |
          fzf --tabstop 1 --ansi -d $'\t' --with-nth=2,3 \
              --preview-window='bottom:10%' --preview 'printf "\x1b[38;5;117m%s\033[0m\n" {1}' |
              awk '{print $1}' | xargs -d '\n' -I{} -n1 -r xdg-open '{}'

    '';
  };

  fif = pkgs.writeShellApplication {
    name = "fif";
    runtimeInputs = with pkgs; [ripgrep-all toybox coreutils];

    text = ''
      #!/usr/bin/env bash
      if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
      file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '""$*""' {}")" && echo "opening $file" && hx "$file" || return 1;

    '';
  };

  # fbu = pkgs.writeShellApplication {
  #   name = "fbu";
  #   runtimeInputs = with pkgs; [buku gawkInteractive toybox sqlite fzf];
  #   text = ''
  #     #!/usr/bin/env bash

  #     # BUKU bookmark manager
  #     # get bookmark ids
  #     get_buku_ids() {
  #         buku -p -f 5 | fzf --tac --layout=reverse-list -m | \
  #           cut -d $'\t' -f 1
  #     }

  #     # buku update
  #     # save newline separated string into an array
  #     mapfile -t ids < <(get_buku_ids)

  #     echo buku --update ${"ids[@]"} "$@"

  #     # [[ -z "${ids [0]}" ]] && return 0 # return if has no bookmark selected

  #     buku --update ${"ids[@]"} "$@"

  #   '';
  # };

  # fbw = pkgs.writeShellApplication {
  #   name = "fbw";
  #   runtimeInputs = with pkgs; [buku gawkInteractive toybox sqlite fzf];
  #   text = ''
  #     #!/usr/bin/env bash

  #     # BUKU bookmark manager
  #     # get bookmark ids
  #     get_buku_ids() {
  #         buku -p -f 5 | fzf --tac --layout=reverse-list -m | \
  #           cut -d $'\t' -f 1
  #     }

  #     # buku update
  #     # save newline separated string into an array
  #     ids=( $(get_buku_ids) )

  #     # update websites
  #     for i in ${ids[@]}; do
  #         echo buku --write "$i"
  #         buku --write "$i"
  #     done

  #   '';
  # };

  fh = pkgs.writeShellApplication {
    name = "fh";
    runtimeInputs = with pkgs; [sqlite coreutils fzf gnugrep gawkInteractive gnused];
    text = ''
      #!/usr/bin/env bash
      # query all of your firefox history by visit date, title or url
      # idea from https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf/
      # from https://github.com/Aloxaf/fzf-tab/tree/7fed01afba9392b6392408b9a0cf888522ed7a10/modules

      sep='{::}'

      cp ~/.mozilla/firefox/*/places.sqlite /tmp

      sqlite3 -separator $sep /tmp/places.sqlite \
        '
        SELECT datetime(v.visit_date/1000000), p.title, p.url FROM moz_places p
        JOIN moz_historyvisits v ON p.id = v.place_id
        GROUP BY p.url
        ORDER BY last_visit_date DESC
        ' |
      awk -F $sep '{printf "%s  \x1b[36m%s  \x1b[m%s\n", $1, $2, $3}' |
      sed -E 's/\x1b\[[0-9;]+m  //g' |
      fzf --ansi --multi |
      grep -oP 'https?://.*$'
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
      wallpaper_path=${wallpaper_path}

      wallpaper_name="$(find "$wallpaper_path" -exec basename {} \; | wofi --show dmenu --sort-order=alphabetical)"
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
      wallpaper_name="$(find ${wallpaper_path} | shuf -n 1)"
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
        wallpaper_name="$(find ${wallpaper_path} | shuf -n 1)"
        w_name="$(echo "$wallpaper_name" | xargs basename)"
        if [[ -f $wallpaper_name ]]; then
            wall-change "$wallpaper_name" &
            notify-send -u normal "Changed Wallpaper to $w_name" &
        else
            exit 1
        fi
        sleep 1800
      done
    '';
  };
}