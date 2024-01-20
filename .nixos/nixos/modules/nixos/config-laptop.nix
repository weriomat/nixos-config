# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ouputs, ... }:

{
  imports = [ ./common/default.nix ./user.nix ];

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

  system.stateVersion = "23.11";
}
