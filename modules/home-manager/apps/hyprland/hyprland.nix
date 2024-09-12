{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.my_hyprland.enable = mkEnableOption "Enable hyrpland config";

  config = mkIf config.my_hyprland.enable {
    home.packages = with pkgs; [
      libnotify
      brightnessctl
      # TODO: here

      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      xwaylandvideobridge
      wf-recorder
      wayland
    ];

    # systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      systemd = {
        enable = true;
        enableXdgAutostart = true; # TODO: here
        extraCommands = [
          "${pkgs.systemd}/bin/systemctl --user restart pipewire polkit-gnome-authentication-agent-1 xdg-desktop-portal xdg-desktop-portal-wlr"
        ];
        variables = ["--all"];
      };

      # TODO: here
      # reloadConfig = true;
      # systemdIntegration = true;
      # recommendedEnvironment = true;
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
            terminal = "${config.programs.kitty.package}/bin/kitty";
          };
        };
      };

      # Support for a redlight filter
      wlsunset = {
        enable = true;
        latitude = "52.5";
        longitude = "13.4";
        systemdTarget = "hyprland-session.target";
      };
    };

    # TODO: here
    # systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];

    # Allow for Hyprland start when tty1 is used, this is a fallback in case the DM fails
    programs.zsh.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
