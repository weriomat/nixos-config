{
  config,
  lib,
  pkgs,
  ...
}:
{
  catppuccin.fzf = {
    enable = true;
    flavor = "mocha";
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d"; # <alt> + c
      changeDirWidgetOptions = [
        "--preview '${pkgs.eza}/bin/eza --tree {} | ${pkgs.toybox}/bin/head -200'"
      ];

      defaultCommand = "${pkgs.fd}/bin/fd --type f"; # fzf
      defaultOptions = [
        "--multi"
        "--height 40%"
        "--border"
      ];

      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f"; # <ctrl> + t
      fileWidgetOptions = [
        "--preview '${config.programs.bat.package}/bin/bat --color=always --style=numbers --line-range=:500 {}'"
      ];

    };
    zsh.envExtra = lib.mkAfter ''
      # Man without options will use fzf to select a page
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

      function fzf-man(){
        MAN="${pkgs.bat-extras.batman}/bin/batman"
        if [ -n "$1" ]; then
          $MAN "$@"
          return $?
        else
          $MAN -k . | ${config.programs.fzf.package}/bin/fzf --reverse --preview="${pkgs.toybox}/bin/echo {1,2} | ${pkgs.toybox}/bin/sed 's/ (/./' | ${pkgs.toybox}/bin/sed -E 's/\)\s*$//' | ${pkgs.toybox}/bin/xargs $MAN" | ${pkgs.gawk}/bin/awk '{print $1 "." $2}' | tr -d '()' | ${pkgs.toybox}/bin/xargs -r $MAN
          return $?
        fi
      }

      # cd into dir of file
      cdf() {
         local file
         local dir
         file=$(${config.programs.fzf.package}/bin/fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
      }
    '';
  };
}
