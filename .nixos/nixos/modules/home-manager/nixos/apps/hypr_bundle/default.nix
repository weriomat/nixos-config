{lib, ...}: {
  imports = [../gtk ../hyprland ../mako ../swaylock ../waybar ../wofi];
  options.hyprland = {
    enable = lib.mkOption {
      type = lib.type.bool;
      default = false;
      description = "Enable hyrpland config";
    };
  };
  config = {
    my_gtk.enable = true;
    my_mako.enable = true;
    swaylock.enable = true;
    wofi.enable = true;
    waybar.enable = true;
    my_hyprland.enable = true;
  };
}
