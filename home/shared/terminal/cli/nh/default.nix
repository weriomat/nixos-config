{
  globals,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf getExe;
in
{
  config = mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.nh ];

    programs.zsh.shellAliases = {
      nh = "FLAKE=/home/${globals.username}/.nixos/nixos ${getExe pkgs.nh}";
    };
  };
}
