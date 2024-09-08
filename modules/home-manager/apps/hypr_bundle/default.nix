{
  lib,
  config,
  ...
}:
with lib; {
  imports = [../gtk ../hyprland ../mako ../swaylock ../waybar ../wofi];
  options.hyprland.enable = mkEnableOption "Enable hyrpland config";

  config = mkIf config.hyprland.enable {
    my_gtk.enable = true;
    my_mako.enable = true;
    swaylock.enable = true;
    wofi.enable = true;
    waybar.enable = true;
    my_hyprland.enable = true;
    wlogout.enable = true;
  };
}
