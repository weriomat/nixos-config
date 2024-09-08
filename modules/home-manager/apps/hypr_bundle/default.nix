{
  lib,
  config,
  ...
}:
with lib; {
  options.hyprland.enable = mkEnableOption "Enable hyprland config";

  config = mkIf config.hyprland.enable {
    my_gtk.enable = true;
    my_mako.enable = true;
    swaylock.enable = true;
    wofi.enable = true;
    waybar.enable = true;
    my_hyprland.enable = true;
    wlogout.enable = true;
    swayidle.enable = true;
  };
}
