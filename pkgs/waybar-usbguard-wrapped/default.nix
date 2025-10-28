{
  writeShellApplication,
  usbguard-dbus,
  ...
}:
writeShellApplication {
  name = "waybar-usbguard";
  runtimeInputs = [
    usbguard-dbus
  ];
  text = ''
    socket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/usbguard-dbus.sock"

    usbguard-dbus -socket "$socket" "$@"
  '';
}
