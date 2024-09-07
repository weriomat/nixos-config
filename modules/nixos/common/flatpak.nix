{
  lib,
  config,
  ...
}:
with lib; {
  options.flatpack.enable = mkEnableOption "Enable flatpack";

  config = mkIf config.flatpack.enable {
    # https://www.flatpak.org/setup/NixOS
    services.flatpak.enable = true;

    # https://gitlab.com/leinardi/gst
    # flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  };
}
