{
  inputs,
  config,
  lib,
  pkgs,
  globals,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe'
    getExe
    ;
in
{
  options.my_hyprland.enable = mkEnableOption "Enable hyrpland config";

  config = mkIf config.my_hyprland.enable {
    home.packages = [
      pkgs.libnotify
      pkgs.brightnessctl
      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      # pkgs.kdePackages.xwaylandvideobridge
      pkgs.wf-recorder
      pkgs.wayland
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage =
      #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # NOTE: this options will be used by the nixos-module as well
      xwayland.enable = true;

      systemd = {
        enable = true;
        enableXdgAutostart = true;
        extraCommands = [
          "${getExe' globals.systemd "systemctl"} --user restart pipewire polkit-gnome-authentication-agent-1 xdg-desktop-portal xdg-desktop-portal-wlr"
        ];
        variables = [
          "--all"
          "XDG_SESSION_TYPE"
          "QT_QPA_PLATFORMTHEME"
          "XDG_CONFIG_HOME"
        ];
      };
    };

    services = {
      # NOTE: start nm-applet, blueblueman-applet at boot
      network-manager-applet.enable = true;
      blueman-applet.enable = true;

      # NOTE: automatic mounting of new devices
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
        settings = {
          program_options = {
            terminal = "${getExe config.programs.kitty.package}";
          };
        };
      };

      # Support for a redlight filter
      # TODO: switch to hyprsunset?
      wlsunset = {
        enable = true;
        latitude = "52.5";
        longitude = "13.4";
        systemdTarget = "hyprland-session.target";
      };
    };

    # Allow for Hyprland start when tty1 is used, this is a fallback in case the DM fails
    programs.zsh.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
