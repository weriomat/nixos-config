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

  cfg = config.services.usbguard-dbus;
in
{
  options.services.usbguard-dbus = {
    enable = mkEnableOption "usbguard-dbus helper for waybar";
    package = mkPackageOption pkgs "usbguard-dbus" { };
  };

  config = mkIf cfg.enable {
    systemd.user = mkIf pkgs.stdenv.isLinux {
      services.usbguard-dbus = {
        Unit.Requires = "usbguard-dbus.sock";

        Service.ExecStart = getExe cfg.package;

        Install = {
          Also = "usbguard-dbus.socket";
          WantedBy = [ "default.target" ];
        };
      };
      sockets.usbguard-dbus = {
        Socket = {
          ListenStream = "%t/usbguard-dbus.sock";
          RemoveOnStop = "yes";
        };

        Install.WantedBy = [ "sockets.target" ];
      };
    };
  };
}
