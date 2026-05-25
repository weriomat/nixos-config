{
  globals,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
in
{
  config = mkIf globals.laptop {
    services = {
      # prevent rubber-ducker attack
      usbguard = {
        enable = true;
        presentControllerPolicy = "apply-policy";
        IPCAllowedGroups = [ "wheel" ];
        dbus.enable = true;
      };
      usbguard-notifier.enable = true; # notifications when a new usb device appears/ disappears
    };
  };
}
