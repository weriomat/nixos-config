{ inputs, config, pkgs, ouputs, ... }:

{
  imports =
    [ ./common/default.nix ./common/flatpak.nix ./user.nix ]; # ./wayland.nix ];

  programs = {
    wireshark.enable = true;
    hyprland.enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  # TODO: gnome -> hyperland
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      layout = "us";
      # xkbVariant = "";
      # videoDrivers = [ "amdgpu" ];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      # # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
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
    gnome.gnome-keyring.enable = true;
  };

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
  # security.pam.services.swaylock = { };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  system.stateVersion = "23.11";
}
