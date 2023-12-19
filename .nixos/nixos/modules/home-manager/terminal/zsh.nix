{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      # Enable Ctrl+arrow key bindings for word jumping
      bindkey '^[[1;5C' forward-word     # Ctrl+right arrow
      bindkey '^[[1;5D' backward-word    # Ctrl+left arrow
    '';

    shellAliases = {
      # config = "/usr/bin/git --git-dir=$HOME/nixos/ --work-tree=$HOME";
      config =
        "/etc/profiles/per-user/marts/bin/git --git-dir=$HOME/.nixos/ --work-tree=$HOME";
      # /etc/profiles/per-user/marts/bin/git
    };

    #   # grep
    #   grep = "grep --color=auto";
    #   ga = "git add";
    #   gb = "git branch";
    #   # alias gc="git clone"
    #   gc = "git commit -m";
    #   gco = "git checkout";
    #   gss = "git status -sb";
    #   gpp = "git push";
    #   gpu = "git pull";

    #   # ssh = "TERM=xterm-256color /usr/bin/env ssh";
    #   test-update = "sudo nixos-rebuild test --flake /home/marts/nixos#default";
    #   update = "sudo nixos-rebuild switch --flake /home/marts/nixos#default";

    # };

  };
}
