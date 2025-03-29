{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hypridle.enable = mkEnableOption "Enable hypridle";

  config = mkIf config.hypridle.enable {
    # from https://github.com/niksingh710/ndots/blob/master/modules/home/hyprland/hypridle.nix
    services.hypridle = {
      enable = true;
      settings =
        let
          timeout = 300;
          loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
        in
        {
          general = {
            lock_cmd = "${pkgs.toybox}/bin/pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
            unlock_cmd = "${lib.getExe pkgs.killall} -q -s SIGUSR1 hyprlock";
            before_sleep_cmd = "${loginctl} lock-session";
            after_sleep_cmd = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
          };

          listener = [
            {
              timeout = timeout - 120;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 15%";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
            }
            {
              timeout = timeout - 30;
              on-timeout = "${pkgs.libnotify}/bin/notify-send -u critical --app-name=screenlockwarning 'Screen will lock in 30 seconds'";
            }
            {
              timeout = timeout - 10;
              on-timeout = "${loginctl} lock-session";
            }

            {
              inherit timeout;
              on-timeout = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms off";
              on-resume = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms on";
            }

            {
              timeout = timeout + 60;
              on-timeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
            }
          ];
        };
    };
  };
}
