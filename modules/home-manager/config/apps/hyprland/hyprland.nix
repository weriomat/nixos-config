{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.my_hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hyrpland config";
    };
  };

  config = lib.mkIf config.my_hyprland.enable {
    home.packages = with pkgs; [
      swayidle
      libnotify

      # TODO: sedtup
      brightnessctl
      # TODO: here

      mpv-unwrapped
      playerctl
      pamixer
      networkmanagerapplet
      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      xwaylandvideobridge
      swaybg
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      wofi
      grim
      slurp
      wl-clipboard # TODO: maybe clipman or cliphist?
      wf-recorder
      glib
      wayland

      # direnv # TODO: what?
      sway-audio-idle-inhibit # no inhbit if audio playing
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      systemd = {
        enable = true;
        enableXdgAutostart = true; # hre
        # extraCommands = []; # move out of config
        # variables = ["--all"];
      };

      # TODO: here
      # reloadConfig = true;
      # systemdIntegration = true;
      # recommendedEnvironment = true;
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
