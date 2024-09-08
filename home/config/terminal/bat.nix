{pkgs, ...}: {
  programs.bat = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch prettybat]; # missing batpipe

    # for highliting if something fales
    # see: https://packagecontrol.io
    syntaxes = {};

    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
          sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  # aliases
  programs.zsh = {
    shellAliases = {
      cat = "bat";
      man = "batman";

      # diff for git
      gdiff = "git diff --name-only --relative --diff-filter=d | xargs bat --diff";

      # open file in helix
      ho = "hx $(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')";

      # kill a process
      kp = "ps aux | fzf | awk '{print$2}' | xargs kill PID";
    };
  };
}
