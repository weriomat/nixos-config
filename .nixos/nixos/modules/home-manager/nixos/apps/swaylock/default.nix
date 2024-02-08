{ pkgs, lib, config, ... }: {
  options.swaylock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swaylock";
    };
  };
  config = lib.mkIf (config.swaylock.enable) {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
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

        color = "${config.colorScheme.palette.base00}";
        bs-hl-color = "${config.colorScheme.palette.base06}";
        caps-lock-bs-hl-color = "${config.colorScheme.palette.base06}";
        caps-lock-key-hl-color = "${config.colorScheme.palette.base0B}";
        ring-color = "${config.colorScheme.palette.base07}";
        ring-clear-color = "${config.colorScheme.palette.base06}";
        ring-caps-lock-color = "${config.colorScheme.palette.base09}";
        ring-ver-color = "${config.colorScheme.palette.base0D}";
        ring-wrong-color = "${config.colorScheme.palette.base0F}";
        text-color = "${config.colorScheme.palette.base05}";
        text-clear-color = "${config.colorScheme.palette.base06}";
        text-caps-lock-color = "${config.colorScheme.palette.base09}";
        text-ver-color = "${config.colorScheme.palette.base0D}";
        text-wrong-color = "${config.colorScheme.palette.base0F}";

        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "${config.colorScheme.palette.base0B}";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "${config.colorScheme.palette.base0D}";
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
