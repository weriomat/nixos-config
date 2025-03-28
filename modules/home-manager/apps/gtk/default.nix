{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my_gtk.enable = mkEnableOption "Enable gtk settings";

  config = mkIf config.my_gtk.enable {
    gtk = {
      enable = true;
      # Alternative     name = "BeautyLine"; package = pkgs.beauty-line-icon-theme;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };
      # Alternative     name = "Juno-ocean"; package = pkgs.juno-theme;
      theme = {
        name = "Catppuccin-Mocha-Compact-Lavender-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "lavender" ];
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
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      #    gtk4 = {
      #      extraConfig = {
      #        gtk-application-prefer-dark-theme = true;
      #      };
      #      # the dark files are not copied by default, as not all themes have separate files
      #      # see: https://github.com/nix-community/home-manager/blob/afcedcf2c8e424d0465e823cf833eb3adebe1db7/modules/misc/gtk.nix#L238
      #      extraCss = ''
      #        @import url("file://${theme.package}/share/themes/${theme.name}/gtk-4.0/gtk-dark.css");
      #      '';
      #    };
    };

    home.pointerCursor = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };
}
