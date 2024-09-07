{
  pkgs,
  lib,
  config,
  ...
}: {
  options.graphical = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable graphical apps";
    };
  };
  config = lib.mkIf config.graphical.enable {
    environment.systemPackages = with pkgs; [
      obsidian
      cider
      polkit_gnome

      # graphical
      endeavour
      gnome.gnome-calendar
      gnome.gnome-control-center
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
