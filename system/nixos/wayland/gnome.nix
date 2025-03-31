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
    rygel.enable = false;
  };

  # castrate gnome
  environment.gnome.excludePackages =
    [
      pkgs.rygel # home media solurtion for sharing video/audio etc.
      pkgs.tinysparql
      pkgs.localsearch
      pkgs.gnome-connections
      pkgs.gnome-photos
      pkgs.gnome-tour
      pkgs.endeavour
      pkgs.gnome-user-docs
      pkgs.gnome-user-share
      pkgs.gnome-text-editor
      pkgs.gnome-console
      pkgs.gnome-weather
      pkgs.gnome-software
      pkgs.gnome-tecla
      pkgs.yelp
      pkgs.orca # Screnreader
    ]
    ++ [
      pkgs.cheese # webcam tool
      pkgs.gnome-remote-desktop
      pkgs.gnome-font-viewer
      pkgs.gnome-music
      pkgs.gnome-logs
      pkgs.gnome-maps
      pkgs.gnome-clocks
      pkgs.gnome-contacts
      pkgs.gnome-characters
      pkgs.epiphany # web browser
      pkgs.geary # email reader
      pkgs.seahorse # password manager
      pkgs.baobab # disk usage analyzer
      pkgs.file-roller # archive manager
      pkgs.totem # video player
      pkgs.tali # poker game
      pkgs.iagno # go game
      pkgs.hitori # sudoku game
      pkgs.atomix # puzzle game
    ];
}
