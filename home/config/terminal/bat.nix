{ pkgs, config, ... }:
{
  catppuccin.bat = {
    enable = true;
    flavor = "mocha";
  };

  programs = {
    bat = {
      enable = true;

      extraPackages = [
        pkgs.bat-extras.batdiff
        pkgs.bat-extras.batman
        pkgs.bat-extras.batgrep
        pkgs.bat-extras.batwatch
        pkgs.bat-extras.prettybat
      ]; # missing batpipe
    };

    # aliases
    zsh = {
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        man = "${pkgs.bat-extras.batman}/bin/batman";

        # diff for git
        gdiff = "git diff --name-only --relative --diff-filter=d | ${pkgs.coreutils}/bin/xargs ${config.programs.bat.package}/bin/bat --diff";

        # open file in helix
        ho = "hx $(${config.programs.fzf.package}/bin/fzf --preview '${config.programs.bat.package} --color=always --style=numbers --line-range=:500 {}')";

        # kill a process
        kp = "ps aux | ${config.programs.fzf.package}/bin/fzf | ${pkgs.gawk}/bin/awk '{print$2}' | ${pkgs.coreutils}/bin/xargs kill PID";
      };
    };
  };
}
