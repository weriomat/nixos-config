{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    # TODO: fix vi keysbindings
    envExtra = ''
      # Enable Ctrl+arrow key bindings for word jumping
      bindkey '^[[1;5C' forward-word     # Ctrl+right arrow
      bindkey '^[[1;5D' backward-word    # Ctrl+left arrow

      bindkey -v
      export KEYTIMEOUT=1

      # vi 
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      # change cursor shape for different vi modes
      function zle-keymap-select() {
        case $KEYMAP in 
          vimcd) echo -ne '\e[1 q';; # block
          viins|main) echo -ne '\e[5 q';; # beam
        esac
      }
      zle -N zle-keymap-select
      zle-line-init(){
        zle -K viins # init vi ins as keymap
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q' # use beam at startup
      preexec(){
        echo -ne '\e[5 q' ; # use beam for each new prompt
      }
    '';

    shellAliases = {
      config =
        "/etc/profiles/per-user/marts/bin/git --git-dir=$HOME/.nixos/ --work-tree=$HOME";

      diff = "diff --color";

      # for c dev # TODO: delete this
      ctest = "nix develop .#dev -c make && pytest test/test_praxis2.py -vvv";

      # grep
      grep = "grep --color=auto";
      ga = "git add";
      gb = "git branch";
      # alias gc="git clone"
      gc = "git commit -m";
      gco = "git checkout";
      gss = "git status -sb";
      gpp = "git push";
      gpu = "git pull";
      # lazygit
      gl = "lazygit";
      # ssh = "TERM=xterm-256color /usr/bin/env ssh";
      test-update =
        "sudo nixos-rebuild test --flake /home/marts/.nixos/nixos#default";
      update =
        "sudo nixos-rebuild switch --flake /home/marts/.nixos/nixos#default";
      updatelap =
        "sudo nixos-rebuild switch --flake /home/marts/.nixos/nixos#laptop";
      rebuildlap =
        "sudo nixos-rebuild switch --flake /home/marts/.nixos/nixos#laptop";
      rebuild =
        "sudo nixos-rebuild switch --flake /home/marts/.nixos/nixos#default";

    };
    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    historySubstringSearch.enable = true;

  };
}
