{
  globals,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
in
{
  home.packages = [ pkgs.nh ];

  programs.zsh.shellAliases = {
    nh = "FLAKE=/home/${globals.username}/.nixos/nixos ${getExe pkgs.nh}";
  };
}
