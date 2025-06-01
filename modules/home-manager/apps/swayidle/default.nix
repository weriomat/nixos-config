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
    getExe'
    getExe
    ;
in
{
  options.swayidle.enable = mkEnableOption "Enable swayidle";

  config = mkIf config.swayidle.enable {
    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      extraArgs = [ "-w" ];

      timeouts = [
        {
          timeout = 550;
          command = "${getExe pkgs.libnotify} -u critical --app-name=screenlockwarning 'Screen will lock in 30 seconds'";
        }
        {
          timeout = 580;
          command = "${getExe config.programs.swaylock.package} -f --grace 20 --fade-in 20";
        }
        {
          timeout = 600;
          command = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms off";
          resumeCommand = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms on";
        }
        {
          timeout = 900;
          command = "${getExe' globals.systemd "systemctl"} suspend";
        }
      ];
    };
  };
}
