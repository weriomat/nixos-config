{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
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
      tracker
      tracker-miners
      gnome-connections
      gnome-photos
      gnome-tour
      endeavour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-remote-desktop
      gnome-font-viewer
      gnome-music
      gnome-logs
      gnome-maps
      gnome-clocks
      gnome-contacts
      epiphany # web browser
      geary # email reader
      gnome-characters
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
