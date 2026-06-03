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

  # TODO: theme gtk
  config = mkIf config.my_gtk.enable {
    # TODO: https://github.com/Sly-Harvey/NixOS/blob/master/modules/themes/Catppuccin/default.nix

    gtk = {
      enable = true;

      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.extraConfig."gtk-application-prefer-dark-theme" = "1";
      gtk4 = {
        extraConfig."gtk-application-prefer-dark-theme" = "1";
        theme = config.gtk.theme;
      };

      theme = {
        name = "catppuccin-mocha-lavender-compact";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "lavender" ];
          size = "compact";
          variant = "mocha";
        };
      };

      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 22;
      };

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
      gtk.enable = true;
      x11.enable = true;
    };

    # FROM: https://github.com/Sly-Harvey/NixOS/blob/9c81fadf81f9d53624b882fcfb7cbcf16181b346/modules/themes/Catppuccin/default.nix
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    xdg.configFile = {
      "gtk-4.0/assets" = {
        force = true;
        source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      };
      "gtk-4.0/gtk.css" = {
        force = true;
        source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      };
      "gtk-4.0/gtk-dark.css" = {
        force = true;
        source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      };
    };
  };
}
