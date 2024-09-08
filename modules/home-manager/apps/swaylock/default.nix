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
