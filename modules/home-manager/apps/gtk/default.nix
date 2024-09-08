{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.my_gtk.enable = mkEnableOption "Enable gtk settings";

  config = mkIf config.my_gtk.enable {
    fonts.fontconfig.enable = true;
    # TODO: here
    home.packages = [
      pkgs.nerdfonts
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      pkgs.twemoji-color-font
      pkgs.noto-fonts-emoji
    ];

    gtk = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };
      theme = {
        name = "Catppuccin-Mocha-Compact-Lavender-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["lavender"];
          size = "compact";
          # tweaks = [ "rimless" ];
          variant = "mocha";
        };
      };
      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 22;
      };
    };

    home.pointerCursor = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };
}
