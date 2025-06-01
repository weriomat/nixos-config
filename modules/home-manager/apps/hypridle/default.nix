{
  config,
  lib,
  pkgs,
  globals,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
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
          loginctl = "${getExe' globals.systemd "loginctl"}";
        in
        {
          general = {
            lock_cmd = "${getExe' pkgs.toybox "pidof"} hyprlock || ${getExe config.programs.hyprlock.package}";
            unlock_cmd = "${getExe pkgs.killall} -q -s SIGUSR1 hyprlock";
            before_sleep_cmd = "${loginctl} lock-session";
            after_sleep_cmd = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms on";
            ignore_dbus_inhibit = false;
          };

          listener = [
            {
              timeout = timeout - 120;
              on-timeout = "${getExe pkgs.brightnessctl} -s set 15%";
              on-resume = "${getExe pkgs.brightnessctl} -r";
            }
            {
              timeout = timeout - 30;
              on-timeout = "${getExe pkgs.libnotify} -u critical --app-name=screenlockwarning 'Screen will lock in 30 seconds'";
            }
            {
              timeout = timeout - 10;
              on-timeout = "${loginctl} lock-session";
            }

            {
              inherit timeout;
              on-timeout = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms off";
              on-resume = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms on";
            }

            {
              timeout = timeout + 60;
              on-timeout = "${getExe' globals.systemd "systemctl"} suspend";
            }
          ];
        };
    };
  };
}
