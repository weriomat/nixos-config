{...}: {
  # https://www.flatpak.org/setup/NixOS
  services.flatpak.enable = true; # added to config.nix
  #  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
  # https://gitlab.com/leinardi/gst
  # flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
