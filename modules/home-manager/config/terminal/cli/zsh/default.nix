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
    };

    history = {
      size = 10000000;
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
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
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
