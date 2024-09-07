{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.graphical.enable = mkEnableOption "Enable graphical apps";

  config = mkIf config.graphical.enable {
    environment.systemPackages = with pkgs; [
      obsidian
      cider
      polkit_gnome

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
