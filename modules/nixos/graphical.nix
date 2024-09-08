{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.graphical.enable = mkEnableOption "Enable graphical apps";

  config = mkIf config.graphical.enable {
    # TODO: make this into package list with ++ syntax
    # TODO: check if i use them
    environment.systemPackages = with pkgs; [
      obsidian
      cider

      # graphical
      gnome.gnome-calendar
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
