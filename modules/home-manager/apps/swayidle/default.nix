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
  options.swayidle.enable = mkEnableOption "Enable swayidle";

  config = mkIf config.swayidle.enable {
    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      extraArgs = [ "-w" ];

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
          command = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
