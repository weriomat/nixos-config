{ config, pkgs, inputs, ouputs, ... }:

{
  imports =
    [ ./common/default.nix ./common/flatpak.nix ./user.nix ./wayland.nix ];

  # TODO: gnome -> hyperland
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      layout = "us";
      # xkbVariant = "";
      # videoDrivers = [ "amdgpu" ];
      # displayManager.gdm.enable = true;
      # # Enable the GNOME Desktop Environment.
      # desktopManager.gnome.enable = true;
      libinput = {
        enable = true;
        # mouse = { accelProfile = "flat"; };
      };
    };
    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
  };

  security.pam.services.swaylock = { };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  system.stateVersion = "23.11";
}
