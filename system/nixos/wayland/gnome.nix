{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  # gnome for backup
  services.xserver.desktopManager.gnome.enable = true;

  services.gnome = {
    core-shell.enable = mkForce true; # Need for basic version of gnome
    core-utilities.enable = mkForce false;
    games.enable = mkForce false;
    core-developer-tools.enable = mkForce false;
  };

  # castrate gnome
  environment.gnome.excludePackages =
    (with pkgs; [
      tinysparql
      localsearch
      gnome-connections
      gnome-photos
      gnome-tour
      endeavour
      gnome-user-docs
      gnome-user-share
      gnome-text-editor
      gnome-console
      gnome-weather
      gnome-software
      gnome-tecla
      yelp
      orca # Screnreader
    ])
    ++ (with pkgs; [
      cheese # webcam tool
      gnome-remote-desktop
      gnome-font-viewer
      gnome-music
      gnome-logs
      gnome-maps
      gnome-clocks
      gnome-contacts
      gnome-characters
      epiphany # web browser
      geary # email reader
      seahorse # password manager
      baobab # disk usage analyzer
      file-roller # archive manager
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
}
