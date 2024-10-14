{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.hyprland.enable = mkEnableOption "Enable hyprland config";

  config = mkIf config.hyprland.enable {
    clipboard.enable = true;
    my_gtk.enable = true;
    mako.enable = true;
    swaylock.enable = true;
    wofi.enable = true;
    waybar.enable = true;
    my_hyprland.enable = true;
    wlogout.enable = true;
    swayidle.enable = true;
    wallpapers.enable = true;
    audio_config.enable = true;
  };
}
