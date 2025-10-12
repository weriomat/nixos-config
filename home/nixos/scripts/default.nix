{ pkgs, ... }:
{
  # TODO: document all shortcuts
  fshow = pkgs.writeShellApplication {
    name = "fshow";
    runtimeInputs = [
      pkgs.sqlite
      pkgs.coreutils
      pkgs.fzf
      pkgs.gnugrep
      pkgs.gawkInteractive
      pkgs.gnused
    ];
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

  fif = pkgs.writeShellApplication {
    name = "fif";
    runtimeInputs = [
      pkgs.ripgrep-all
      pkgs.toybox
      pkgs.coreutils
    ];

    text = ''
      #!/usr/bin/env bash
      if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
      file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '""$*""' {}")" && echo "opening $file" && hx "$file" || return 1;

    '';
  };

  fh = pkgs.writeShellApplication {
    name = "fh";
    runtimeInputs = [
      pkgs.sqlite
      pkgs.coreutils
      pkgs.fzf
      pkgs.gnugrep
      pkgs.gawkInteractive
      pkgs.gnused
    ];
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
  #   runtimeInputs = [ pkgs.killall ];
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
    runtimeInputs = [ pkgs.hyprland ];
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
