_: {
  catppuccin.imv.enable = true;
  programs.imv = {
    enable = true;
    settings = {
      options = {
        overlay_font = "Iosevka Nerd Font:10";
      };
      binds = {
        # Rotate Clockwise by 90 degrees
        "<Ctrl+r>" = "rotate by 90";
      };
    };
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
  ];
}
