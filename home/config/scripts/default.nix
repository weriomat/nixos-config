{pkgs, ...}: {
  # TODO: here
  # stolen from https://haseebmajid.dev/posts/2023-11-15-part-3-hyprland-as-part-of-your-development-workflow/
  laptop_lid_switch = pkgs.writeShellScriptBin "laptop_lid_switch" ''
    #!/usr/bin/env bash

    if grep open /proc/acpi/button/lid/LID0/state; then
        hyprctl keyword monitor "eDP-1, 2256x1504@60, 0x0, 1"
    else
        if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
            hyprctl keyword monitor "eDP-1, disable"
        fi
    fi
  '';

  # stolen from https://gitlab.com/Zaney/zaneyos/-/blob/main/scripts/web-search.nix?ref_type=heads
  web-search = pkgs.writeShellApplication {
    name = "web-search";
    runtimeInputs = with pkgs; [hyprland swayidle swaylock libnotify];
    text = ''
       declare -A URLS

       URLS=(
         ["🌎 Search"]="https://duckduckgo.com/?q="
         ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
         ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
         ["🦥 Arch Wiki"]="https://wiki.archlinux.org/title/"
         ["🐃 Gentoo Wiki"]="https://wiki.gentoo.org/index.php?title="
       )

       # List for rofi
       gen_list() {
         for i in "''${!URLS[@]}"
         do
           echo "$i"
         done
       }

       main() {
         # Pass the list to rofi
         platform=$( (gen_list) | ${pkgs.wofi}/bin/wofi -dmenu )

         if [[ -n "$platform" ]]; then
           query=$( (echo ) | ${pkgs.wofi}/bin/wofi -dmenu )

           if [[ -n "$query" ]]; then
      url=''${URLS[$platform]}$query
      xdg-open "$url"
           else
      exit
           fi
         else
           exit
         fi
       }

       main

       exit 0
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

  # TODO: here, exec at start of hyprland
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
}
