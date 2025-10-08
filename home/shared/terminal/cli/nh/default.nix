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
  config = {
    home.packages = [ pkgs.nh ];
    programs.zsh.shellAliases.nh =
      if pkgs.stdenv.isLinux then
        "NH_FLAKE=/home/${globals.username}/.nixos/nixos ${getExe pkgs.nh}"
      else
        "";
  };
}
