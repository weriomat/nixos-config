{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe getExe';
in
{
  home.packages = [ pkgs.manix ];
  programs.zsh.shellAliases.ma = ''${getExe pkgs.manix} "" | ${getExe pkgs.gnugrep} '^# ' | ${getExe pkgs.gnused} 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | ${getExe config.programs.fzf.package} --preview="${getExe pkgs.manix} '{}'" | ${getExe' pkgs.toybox "xargs"} ${getExe pkgs.manix}'';
}
