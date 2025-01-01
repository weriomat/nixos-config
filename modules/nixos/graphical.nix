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
    # TODO: make this into package list with ++ syntax
    # TODO: check if i use them
    environment.systemPackages = with pkgs; [
      obsidian
      unstable.cider

      # graphical
      gnome-calendar
      xfce.thunar

      # media
      pavucontrol
      smartmontools
      inkscape
      vlc
      glxinfo
      vdpauinfo

      # office
      libreoffice
      pandoc
      keepassxc
      evince
    ];
  };
}
