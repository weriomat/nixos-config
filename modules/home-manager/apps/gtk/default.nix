{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.my_gtk.enable = mkEnableOption "Enable gtk settings";

  config = mkIf config.my_gtk.enable {
    fonts.fontconfig = {
      enable = true;
      # TODO: fonts -> fira code
      # defaultFonts = {
      #   serif = ["Source Serif" "Noto Color Emoji"];
      #   sansSerif = ["Fira Sans" "FiraGO" "Noto Color Emoji"];
      #   monospace = ["MonoLisa Nerd Font" "Noto Color Emoji"];
      #   emoji = ["Noto Color Emoji"];
      # };
      # in normal nixos options
      #     fonts.packages = with pkgs; [
      #   (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
      #   cm_unicode
      #   corefonts
      # ];

      # TODO: emoji picker https://discourse.nixos.org/t/emoji-picker-and-fancyzones-alternative/38461/2
      # TODO: https://discourse.nixos.org/t/how-to-set-system-wide-default-emoji-font/15754/5
      # TODO: https://discourse.nixos.org/t/guidelines-on-packaging-fonts/7683/2
    };

    home.packages = [
      (pkgs.nerdfonts.override {fonts = ["IBMPlexMono"];})
      # pkgs.nerdfonts
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      # pkgs.twemoji-color-font
      pkgs.iosevka-comfy.comfy
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
