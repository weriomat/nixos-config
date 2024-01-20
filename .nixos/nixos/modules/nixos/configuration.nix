{ config, pkgs, inputs, ouputs, ... }:

{
  imports = [ ./common/default.nix ./common/flatpak.nix ./user.nix ];

  # TODO: gnome -> hyperland
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager.gdm.enable = true;
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";
      # videoDrivers = [ "amdgpu" ];
    };
    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  system.stateVersion = "23.11";
}
