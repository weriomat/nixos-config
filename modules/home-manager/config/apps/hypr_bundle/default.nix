{
  lib,
  config,
  ...
}: {
  imports = [../gtk ../hyprland ../mako ../swaylock ../waybar ../wofi];
  options.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hyrpland config";
    };
  };
  config = lib.mkIf config.hyprland.enable {
    my_gtk.enable = true;
    my_mako.enable = true;
    swaylock.enable = true;
    wofi.enable = true;
    waybar.enable = true;
    my_hyprland.enable = true;
    wlogout.enable = true;
    prism.enable = true;
  };
}
