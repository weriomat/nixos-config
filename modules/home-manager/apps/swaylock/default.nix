{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.swaylock.enable = mkEnableOption "Enable swaylock";

  config = mkIf config.swaylock.enable {
    wayland.windowManager.hyprland.settings.exec-once = [
      "${config.programs.swaylock.package}/bin/swaylock"
    ];

    catppuccin.swaylock = {
      enable = true;
      flavor = "mocha";
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        clock = true;
        datestr = "";
        screenshots = true;
        show-failed-attempts = true;

        # TODO: font
        # font
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
  };
}
