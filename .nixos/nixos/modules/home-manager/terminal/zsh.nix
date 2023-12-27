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
      config =
        "/etc/profiles/per-user/marts/bin/git --git-dir=$HOME/.nixos/ --work-tree=$HOME";

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

    # TODO: either use startship or 10k...

  };
}
