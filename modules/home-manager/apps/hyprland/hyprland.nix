{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.my_hyprland.enable = mkEnableOption "Enable hyrpland config";

  config = mkIf config.my_hyprland.enable {
    home.packages = with pkgs; [
      libnotify
      brightnessctl
      # TODO: here

      playerctl
      pamixer
      networkmanagerapplet
      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      xwaylandvideobridge
      swaybg
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      grim
      slurp
      wl-clipboard # TODO: maybe clipman or cliphist?
      wf-recorder
      wayland

      sway-audio-idle-inhibit # no inhbit if audio playing
    ];

    # systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      systemd = {
        enable = true;
        enableXdgAutostart = true; # TODO: here
        # extraCommands = []; # move out of config
        # variables = ["--all"];
      };

      # TODO: here
      # reloadConfig = true;
      # systemdIntegration = true;
      # recommendedEnvironment = true;
    };

    # NOTE: automatic mounting of new devices
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
      settings = {
        program_options = {
          terminal = "${config.programs.kitty.package}/bin/kitty";
        };
      };
    };
    # TODO: here
    # systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];

    # Support for a redlight filter
    services.wlsunset = {
      enable = true;
      package = pkgs.wlsunset;
      latitude = "52.5";
      longitude = "13.4";
      systemdTarget = "hyprland-session.target";
    };

    # Allow for Hyprland start when tty1 is used, this is a fallback in case the DM fails
    programs.zsh.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
