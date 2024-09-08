{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.swaylock.enable = mkEnableOption "Enable swaylock";

  config = mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      catppuccin = {
        enable = true;
        flavor = "mocha";
      };

      settings = {
        clock = true;
        datestr = "";
        screenshots = true;
        show-failed-attempts = true;
        # font-size = 24;

        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 7;

        effect-blur = "7x5";
        effect-vignette = "0.5:0.5";

        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        separator-color = "00000000";
      };
    };

    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      extraArgs = ["-w"];

      timeouts = [
        {
          timeout = 550;
          command = "${pkgs.libnotify}/bin/notify-send -u critical --app-name=screenlockwarning 'Screen will lock in 30 seconds'";
        }
        {
          timeout = 580;
          command = "${config.programs.swaylock.package}/bin/swaylock -f --grace 20 --fade-in 20";
        }
        {
          timeout = 600;
          command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
