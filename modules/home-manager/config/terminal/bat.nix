{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      # TODO: here
      # theme = "";
    };
    # TODO: here use them
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch prettybat]; # missing batpipe
    # for highliting if something fales
    # see: https://packagecontrol.io
    syntaxes = {};
    themes = {
      cattpuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
          sha256 = "";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  # aliases
  programs.zsh = {
    # bat as man previewer
    # TODO: set batman as man pagae wieverw
    # TODO: set color theme
    # envExtra = ''
    #   export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    # '';
    shellAliases = {
      cat = "bat";
      # seach for files with preview
      # fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"

      # diff for git
      gdiff = "git diff --name-only --relative --diff-filter=d | xargs bat --diff";
    };
  };
}
