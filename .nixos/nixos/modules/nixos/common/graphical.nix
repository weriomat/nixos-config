{pkgs, ...}: {
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
}
