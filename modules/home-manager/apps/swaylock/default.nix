{
  pkgs,
  lib,
  config,
  ...
}: {
  options.swaylock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swaylock";
    };
  };
  config = lib.mkIf config.swaylock.enable {
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

    # services.swayidle = {
    #   enable = true;
    #   events = [
    #     {
    #       event = "before-sleep";
    #       command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
    #     }
    #     {
    #       event = "lock";
    #       command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
    #     }
    #   ];
    #   timeouts = [
    #     {
    #       timeout = 90;
    #       command = "swaylock";
    #     }
    #     {
    #       timeout = 300;
    #       command = "systemctl suspend";
    #     }
    #     {
    #       timeout = 180;
    #       command = "systemctl suspend";
    #       # command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
    #       # resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
    #     }
    #   ];
    # };

    # systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  };
}
