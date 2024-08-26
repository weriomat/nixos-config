{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  # only make this on linux env
  home.packages = with pkgs; [protonmail-bridge pass-wayland];
}
