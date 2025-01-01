{ pkgs, ... }:
{
  catppuccin.bat = {
    enable = true;
    flavor = "mocha";
  };

  programs.bat = {
    enable = true;

    # TODO: less
    #  # Less colors
    # export LESS_TERMCAP_mb=$'\e[1;32m'
    # export LESS_TERMCAP_md=$'\e[1;32m'
    # export LESS_TERMCAP_me=$'\e[0m'
    # export LESS_TERMCAP_se=$'\e[0m'
    # export LESS_TERMCAP_so=$'\e[01;33m'
    # export LESS_TERMCAP_ue=$'\e[0m'
    # export LESS_TERMCAP_us=$'\e[1;4;31m'

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
      prettybat
    ]; # missing batpipe

    # for highliting if something fales
    # see: https://packagecontrol.io
    syntaxes = { };

    # TODO: check if deprecated since catppuccin nix
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
      cat = "${pkgs.bat}/bin/bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";

      # TODO: paths
      # diff for git
      gdiff = "git diff --name-only --relative --diff-filter=d | xargs bat --diff";

      # TODO: move these into zsh why they herre
      # open file in helix
      ho = "hx $(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')";

      # kill a process
      kp = "ps aux | fzf | awk '{print$2}' | xargs kill PID";
    };
  };
}
