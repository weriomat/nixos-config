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
  options.hyprlock.enable = mkEnableOption "Enable hyprlock";

  config = mkIf config.hyprlock.enable {
    catppuccin.hyprlock = {
      enable = true;
      flavor = "mocha";
    };

    # Stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/hyprland/hyprlock.nix
    # unlock hyprlock from other tty via `kill -USR1 hyprlock`
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = false;
          ignore_empty_input = true;
          fractional_scaling = 0;
        };

        background = [
          {
            monitor = "";
            path = "${pkgs.weriomat-wallpapers}/wallpapers/deer-sunset.jpg";
            blur_passes = 2;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];
      };
    };
  };
}
