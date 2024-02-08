{
  pkgs,
  config,
  lib,
  ...
}: {
  # imports = if pkgs.stdenv.isLinux then [
  #   ./firefox
  #   ./vscodium
  #   ./kitty
  #   ./discord
  #   ./mako
  #   ./waybar
  #   ./hyprland
  #   ./wofi
  #   ./gtk
  #   ./swaylock
  # ] else [
  #   ./vscodium
  #   ./kitty
  # ];
  imports = [
    ./firefox
    ./vscodium
    ./kitty
    ./discord
    ./mako
    ./waybar
    ./hyprland
    ./wofi
    ./gtk
    ./swaylock
  ];
}
