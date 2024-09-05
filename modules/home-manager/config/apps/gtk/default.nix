{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my_gtk = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gtk settings";
    };
  };
  config = lib.mkIf config.my_gtk.enable {
    fonts.fontconfig.enable = true;
    # TODO: here
    # fonts.fontconfig.defaultFonts = {
    #   serif = ["Source Serif" "Noto Color Emoji"];
    #   sansSerif = ["Fira Sans" "FiraGO" "Noto Color Emoji"];
    #   monospace = ["MonoLisa Nerd Font" "Noto Color Emoji"];
    #   emoji = ["Noto Color Emoji"];
    # };

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
