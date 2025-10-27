{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    getExe
    ;
  cfg = config.services.usbguard-notifier;
in
{
  options.services.usbguard-notifier = {
    enable = mkEnableOption "usbguard notifier";
    package = mkPackageOption pkgs "usbguard-notifier" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # we need the dbus interface
    services.usbguard.dbus.enable = true;

    # Note this is a user unit as mako is a user unit
    systemd.user.services.usbguard-notifier = {
      description = "USBGuard Notifier Service";

      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        BusName = "org.usbguard1";
        ExecStart = getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };
}
