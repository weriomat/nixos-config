{lib, ...}:
# TODO: swayidle setup in home-manager -> screen goes dark, movie watching do not disturbe https://gist.github.com/johanwiden/900723175c1717a72442f00b49b5060c
# TODO: gnome polkit
# TODO: gnome agendt ssh idk shit
# TODO: portals fix: -> script,
# TODO: improve hyprland config
# TODO: laptop power management
# TODO: brightnessctl
# TODO: waybar status -> corectl etc
# TODO: fix discord links -> https://lemmy.ml/post/1557630
# TODO: hyprland fix hyprland setup -> vimjoyer video
# TODO: cloudflare dns
{
  imports = [./user ./wayland ./common ./steam];

  audio.enable = true;
  doc.enable = true;
  graphical.enable = true;
  keyboard.enable = true;
  networking.enable = true;
  nix-settings.enable = true;
  packages.enable = true;

  # ssd thingie
  services.fstrim.enable = lib.mkDefault true;

  virt.enable = false;
  flatpack.enable = true;
  system.stateVersion = "23.11";
}
