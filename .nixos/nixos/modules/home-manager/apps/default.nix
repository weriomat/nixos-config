{ pkgs, config, ... }: {
  imports = [
    ./firefox
    ./vscodium
    ./kitty
    # ./mako
    # ./waybar
    # ./hyprland
    # ./wofi
    # ./gtk
    # ./swaylock
  ];
}
