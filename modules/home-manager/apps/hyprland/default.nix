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
  cfg = config.my_hyprland;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    ./config.nix
    ./settings.nix
    ./binds.nix
    ./windowrules.nix
  ];

  options.my_hyprland.enable = mkEnableOption "Enable hyrpland config";
  # TODO: https://github.com/Vladimir-csp/uwsm?tab=readme-ov-file

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.libnotify
      pkgs.brightnessctl
      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      # pkgs.kdePackages.xwaylandvideobridge
      pkgs.wf-recorder
      pkgs.wayland
    ];

    # from https://github.com/Sly-Harvey/NixOS/commit/6c47a6d22ad09f93d9bf62bdb69387e7762f2c92
    # portal for sharing (file pickers), gtk will be enabled by gnome
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      xdgOpenUsePortal = true;
      configPackages = [ config.wayland.windowManager.hyprland.package ];
      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.OpenURI" = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Print" = "gtk";
      };
    };

    # TODO: https://github.com/Duckonaut/split-monitor-workspaces?tab=readme-ov-file -> pin workspaces to monitors and independent numbering
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
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
        settings.program_options.terminal = "${getExe config.programs.kitty.package}";
      };

      # Support for a redlight filter
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
