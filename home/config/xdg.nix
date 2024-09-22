# TODO: here
{
  config,
  pkgs,
  ...
}: let
  browser = ["firefox"];
  imageViewer = ["org.gnome.Loupe"];
  videoPlayer = ["io.github.celluloid_player.Celluloid"];
  audioPlayer = ["io.bassi.Amberol"];

  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "svg" "jpeg" "gif"];
  video = xdgAssociations "video" videoPlayer ["mp4" "avi" "mkv"];
  audio = xdgAssociations "audio" audioPlayer ["mp3" "flac" "wav" "aac"];
  browserTypes =
    (xdgAssociations "application" browser [
      "json"
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "ftp"
      "http"
      "https"
      "unknown"
    ]);

  # XDG MIME types
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf"];
      "text/html" = browser;
      "text/plain" = ["Helix"];
      "x-scheme-handler/chrome" = ["chromium-browser"];
      "inode/directory" = ["yazi"];
    }
    // image
    // video
    // audio
    // browserTypes);
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  # TODO: here
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # TODO: here
  # pgcli # modern postgres client

  # xdg.portal = {
  #   enable = true;
  #   config = {
  #     common = {
  #       default = ["hyprland"];
  #     };
  #     hyprland = {
  #       default = ["gtk" "hyprland"];
  #     };
  #   };
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     xdg-desktop-portal-hyprland
  #   ];
  #   xdgOpenUsePortal = true;
  # };

  # services = {
  #      flameshot = {
  #        enable = true;
  #        settings = {
  #          General = {
  #            showStartupLaunchMessage = false;
  #          };
  #        };
  #      };

  #      gnome-keyring = {
  #        enable = false;
  #        components = [ "pkcs11" "secrets" "ssh" ];
  #      };
  #    };

  # TODO: fonots
  # Making fonts accessible to applications.
  # fonts.packages = with pkgs; [
  #   customFonts
  #   font-awesome
  #   myfonts.flags-world-color
  #   myfonts.icomoon-feather
  # ];
  #  customFonts = pkgs.nerdfonts.override {
  #   fonts = [
  #     "JetBrainsMono"
  #     "Iosevka"
  #   ];
  # };

  # TODO: gtk
  # gtk = rec {
  #    enable = true;
  #    iconTheme = {
  #      name = "BeautyLine";
  #      package = pkgs.beauty-line-icon-theme;
  #    };
  #    theme = {
  #      name = "Juno-ocean";
  #      package = pkgs.juno-theme;
  #    };
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
  #  };

  home.packages = [
    # used by `gio open` and xdp-gtk
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      foot "$@"
    '')
    pkgs.xdg-utils
  ];
}
