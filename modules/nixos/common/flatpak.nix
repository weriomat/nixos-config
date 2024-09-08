{
  lib,
  config,
  ...
}: {
  options.flatpack = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable flatpack";
    };
  };
  config = lib.mkIf config.flatpack.enable {
    # https://www.flatpak.org/setup/NixOS
    services.flatpak.enable = true; # added to config.nix
    # https://gitlab.com/leinardi/gst
    # flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  };
}
