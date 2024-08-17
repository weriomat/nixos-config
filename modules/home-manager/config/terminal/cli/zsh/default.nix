{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    # adds 0.15 sek to startup time
    syntaxHighlighting.enable = true;

    envExtra = ''
      # # If not running interactively, don't do anything and return early
      # [[ -o interactive ]] || exit 0
      # Enable Ctrl+arrow key bindings for word jumping
      bindkey '^[[1;5C' forward-word     # Ctrl+right arrow
      bindkey '^[[1;5D' backward-word    # Ctrl+left arrow

      # Fix an issue with tmux.
      export KEYTIMEOUT=1
      # Use vim bindings.
      set -o vi

      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Man without options will use fzf to select a page
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

      function fzf-man(){
        MAN="/etc/profiles/per-user/marts/bin/batman"
        if [ -n "$1" ]; then
          $MAN "$@"
          return $?
        else
          $MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
          return $?
        fi
      }

      # better cd
      cdd() {
          DIR=`fd * -maxdepth 0 -type d -print 2> /dev/null | fzf-tmux` \
          && cd "$DIR"
      }

      # cd into dir of file
      cdf() {
         local file
         local dir
         file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
      }
    '';

    shellAliases = {
      diff = "diff --color";

      # grep
      grep = "grep --color=auto";
      ga = "git add";
      gb = "git branch";
      gc = "git commit -m";
      gco = "git checkout";
      gss = "git status -sb";
      gpp = "git push";
      gpu = "git pull";
      # lazygit
      gl = "lazygit";

      ssh = "TERM=xterm-256color /usr/bin/env ssh";

      # format nix flake
      format-flake = "cd $HOME/.nixos/nixos && nix fmt && cd -";

      # alternative to cmds
      ping = "prettyping";
      df = "duf --all --theme dark";
      dig = "dog";
      du = "dust";

      # manix fzf
      ma = ''manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix'';

      raspi = "ssh -i ~/.ssh/id_ed25519 -p 2077 marts@192.168.178.21";

      # check nix flake
      check-flake = "cd $HOME/.nixos/nixos && nix flake check && cd -";

      # nix shell
      nd = "nix develop -c zsh";

      # fho
      fho = "fh | xargs firefox";
      fhc = "fh | wl-copy";

      # no
      no = "nh os switch";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };

    history = {
      size = 100000; # this probably slows down shell history opening
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    historySubstringSearch.enable = true;

    initExtraBeforeCompInit = ''
      export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-mocha)"
    '';

    plugins = [
      # vi mode and fzf tab add 0.007 to startup time
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "7fed01afba9392b6392408b9a0cf888522ed7a10";
          sha256 = "sha256-ilUavAIWmLiMh2PumtErMCpOcR71ZMlQkKhVOTDdHZw=";
        };
      }

      # {
      #   name = "emoji-cli";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "babarot";
      #     repo = "emoji-cli";
      #     rev = "0fbb2e48e07218c5a2776100a4c708b21cb06688";
      #     sha256 = "sha256-ilUavAIWmLiMh2PumtErMCpOcR71ZMlQkKhVOTDdHZw=";
      #   };
      #   file = "emoji-cli.plugin.zsh";
      # }

      # This plugin is mega slow -> slows down startup by 1.4sek
      # {
      #   name = "fast-syntax-highlighting";
      #   src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      # }

      # {
      #   name = "zsh-completion";
      #   src = "${pkgs.zsh-completions}/zsh-completions.plugin.zsh";
      # }
      # {
      #   name = "forgit";
      #   src = "${pkgs.zsh-forgit}/forgit.plugin.zsh";
      # }
      # {
      #   name = "enhancd";
      #   file = "init.sh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "b4b4r07";
      #     repo = "enhancd";
      #     rev = "v2.2.1";
      #     sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
      #   };
      # }
      #   {
      #     name = "zsh-nix-shell";
      #     file = "nix-shell.plugin.zsh";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "chisui";
      #       repo = "zsh-nix-shell";
      #       rev = "v0.8.0";
      #       sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      #     };
      #   }
    ];
  };
}
