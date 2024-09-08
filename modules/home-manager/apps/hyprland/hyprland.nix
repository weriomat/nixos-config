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
      swayidle
      libnotify

      # TODO: sedtup
      brightnessctl

      # TODO: here
      mpv-unwrapped
      playerctl
      pamixer
      networkmanagerapplet
      udiskie
      # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      xwaylandvideobridge
      swaybg
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      grim
      slurp
      wl-clipboard
      wf-recorder
      glib
      wayland
      sway-audio-idle-inhibit # no inhbit if audio playing
    ];
    systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      systemd.enable = true;
    };

    # Support for a redlight filter
    services.wlsunset = {
      enable = true;
      package = pkgs.wlsunset;
      latitude = "52.5";
      longitude = "13.4";
      systemdTarget = "sway-session.target";
    };

    # Allow for Hyprland start when tty1 is used, this is a fallback in case the DM fails
    programs.zsh.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}