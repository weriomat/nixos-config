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
  config = lib.mkIf (config.graphical.enable) {
    environment.systemPackages = with pkgs; [
      # TODO: maybe use an overlay to get latest version
      # discord
      obsidian
      cider
      polkit_gnome

      # graphical
      gnome.gnome-todo
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
      texlive.combined.scheme-full
      pandoc
      keepassxc
    ];
  };
}
