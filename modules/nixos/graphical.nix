{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.graphical.enable = mkEnableOption "Enable graphical apps";

  config = mkIf config.graphical.enable {
    environment.systemPackages = [
      # to categorize
      pkgs.unstable.cider # apple music player
      pkgs.zotero # research paper assitant, note that the betterbibtex extension was installed manually
      pkgs.gnome-disk-utility
      pkgs.gnome-calendar # calendar

      # media
      pkgs.smartmontools # smart mon
      pkgs.inkscape # drawing
      pkgs.vlc # video watching
      pkgs.glxinfo # info about glx
      pkgs.vdpauinfo # info on vdpau drivers -> which media codecs are supported

      # office
      pkgs.libreoffice # office
      pkgs.pandoc # convert between documents
      pkgs.keepassxc # passowrd manager
      pkgs.evince # pdf viewer
    ];
  };
}
