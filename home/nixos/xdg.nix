# FROM: https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/xdg-mimes.nix
{
  globals,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  # TODO: yt
  # programs.freetube = {
  #   enable = true;
  #   settings = {
  #     allowDashAv1Formats = true;
  #     checkForUpdates = false;
  #     defaultQuality = "1080";
  #     baseTheme = "catppuccinMocha";
  #   };
  # };

  # TODO: programs.yt-dlp = {}; # Dowoloader for yt files  # TODO: switch to mpv
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/security-services.nix
  # https://home-manager-options.extranix.com/?query=mpv&release=release-24.11
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/home/.config/hypr/hyprland.conf
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/rust.nix
  # https://github.com/ivankovnatsky/nixos-config/blob/main/machines/beelink/journald.nix
  # https://celluloid-player.github.io/
  # https://github.com/Vladimir-csp/uwsm?tab=readme-ov-file
  # https://github.com/niksingh710/ndots/blob/master/modules/home/programs/default.nix
  # https://github.com/nomadics9/dotfiles/blob/main/scripts/keybind.sh

  browser = [ "firefox" ];
  imageViewer = [ "imv.desktop" ];
  videoPlayer = [ "io.github.celluloid_player.Celluloid" ];
  audioPlayer = [ "io.bassi.Amberol" ];
  editorMain = [ "Helix" ];
  pdfViewer = [ "org.gnome.Evince" ];
  email = [ "thunderbird" ];
  # TODO: figure out how to disable pdf-arranger
  # TODO: xdg-ninja

  xdgAssociations =
    type: program: list:
    builtins.listToAttrs (
      map (e: {
        name = "${type}/${e}";
        value = program;
      }) list
    );

  pdf =
    (xdgAssociations "application" pdfViewer [
      "pdf"
      "vnd.ms-powerpoint"
    ])
    // (xdgAssociations "image" pdfViewer [ "vnd.djvu" ]);

  image = xdgAssociations "image" imageViewer [
    "png"
    "svg"
    "jpeg"
    "gif"
    # added
    "bmp"
    "jpg"
    "jxl"
    "avif"
    "heif"
    "tiff"
    "webp"
    "x-eps"
    "x-ico"
    "x-psd"
    "x-tga"
    "x-icns"
    "x-webp"
    "svg+xml"
    "x-xbitmap"
    "x-xpixmap"
    "x-portable-bitmap"
    "x-portable-pixmap"
    "x-portable-graymap"
  ];

  mail =
    (xdgAssociations "x-scheme-handler" email [
      "mailto"
      "mid"
      "news"
      "snews"
      "nntp"
      "feed"
      "webcals"
      "webcal"
    ])
    // (xdgAssociations "application" email [
      "rss+xml"
      "x-extension-rss"
      "x-extension-ics"
    ])
    // (xdgAssociations "text" email [
      "calendar"
      "x-vcard"
    ])
    // (xdgAssociations "message" email [ "rfc822" ]);

  video =
    (xdgAssociations "video" videoPlayer [
      "mp4"
      "avi"
      "mkv"
      # added
      "dv"
      "3gp"
      "avi"
      "fli"
      "flv"
      "mp4"
      "ogg"
      "divx"
      "mp2t"
      "mpeg"
      "webm"
      "3gpp"
      "3gpp2"
      "mp4v-es"
      "msvideo"
      "quicktime"
      "vnd.divx"
      "vnd.mpegurl"
      "vnd.rn-realvideo"
      "x-avi"
      "x-flv"
      "x-m4v"
      "x-ogm"
      "x-mpeg2"
      "x-ms-asf"
      "x-ms-wmv"
      "x-ms-wmx"
      "x-ms-wvx"
      "x-ms-wm"
      "x-ms-wmp"
      "x-ms-wmz"
      "x-theora"
      "x-msvideo"
      "x-ogm+ogg"
      "x-matroska"
      "x-matroska-3d"
      "x-theora+ogg"
    ])
    // (xdgAssociations "application" videoPlayer [ "x-matroska" ]);

  audio = xdgAssociations "audio" audioPlayer [
    "mp3"
    "flac"
    "wav"
    "aac"
    # added
    "mp4"
    "ogg"
    "mpeg"
    "x-mp3"
    "x-wav"
    "vorbis"
    "x-flac"
    "mpegurl"
    "x-scpls"
    "x-speex"
    "x-ms-wma"
    "x-vorbis"
    "x-mpegurl"
    "x-oggflac"
    "x-musepack"
    "x-vorbis+ogg"
    "x-pn-realaudio"
    "vnd.rn-realaudio"
  ];

  browserTypes =
    (xdgAssociations "application" browser [
      "json"
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
      # added
      "xhtml+xml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "ftp"
      "http"
      "https"
      "unknown"
      # added
      "chrome"
    ])
    // (xdgAssociations "text" browser [ "html" ]); # added

  editor =
    (xdgAssociations "text" editorMain [
      "plain"
      "rhtml"
      "x-tex"
      "x-java"
      "x-ruby"
      "x-cmake"
      "markdown"
      "x-python"
      "x-readme"
      "x-markdown"
      "x-c++hdr"
      "x-c++src"
      "x-chdr"
      "x-csrc"
      "x-java"
      "x-moc"
      "x-pascal"
      "x-tcl"
      "x-tex"
      "x-c"
      "x-c++"
      "x-nix"
    ])
    // (xdgAssociations "inode" editorMain [ "x-empty" ])
    // (xdgAssociations "application" editorMain [
      "json"
      "x-ruby"
      "x-yaml"
      "x-docbook+xml"
      "x-shellscript"
    ]);

  # XDG MIME types
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) (
    {
      "text/html" = browser;
      "x-scheme-handler/chrome" = [ "chromium-browser" ];
      "inode/directory" = [ "yazi" ];
    }
    // image
    // video
    // audio
    // browserTypes
    // editor
    // pdf
    // mail
  );
in
{
  config = mkIf pkgs.stdenv.isLinux {
    home.sessionVariables = {
      XDG_RUNTIME_DIR = "/run/user/${toString globals.uid}";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      _JAVA_OPTIONS = ''-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java'';
      GOPATH = "${config.xdg.dataHome}/go";
      GOBIN = "${config.xdg.dataHome}/go/bin";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      ZDOTDIR = ''"$HOME"/${config.programs.zsh.dotDir}'';
      IPYTHONDIR = "${config.xdg.dataHome}/ipython";
      JUPYTER_CONFIG_DIR = "${config.xdg.cacheHome}/jupyter";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      TEXMFHOME = "${config.xdg.stateHome}/texmf";
      TEXMFVAR = "${config.xdg.cacheHome}/texmf";
      TEXMFCONFIG = "${config.xdg.stateHome}/texmf";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm/npmrc";
      NPM_CONFIG_CACHE = "${config.xdg.dataHome}/npm";
      NPM_CONFIG_PREFIX = "${config.xdg.stateHome}/npm";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      BUNDLE_USER_CONFIG = "${config.xdg.stateHome}/bundle";
      BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
      BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
    };

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
        extraConfig.XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        publicShare = null;
        templates = null;
        desktop = null;
        music = null;
      };
    };

    # services = {
    #      flameshot = {
    #        enable = true;
    #        settings.General.showStartupLaunchMessage = false;
    #      };
    #      gnome-keyring = {
    #        enable = false;
    #        components = [ "pkcs11" "secrets" "ssh" ];
    #      };
    #    };

    # TODO: git https://github.com/saygo-png/nixos/blob/main/configuration.nix
    # extraConfig = {
    #           color.ui = "auto";
    #           pull.rebase = true;
    #           commit.gpgsign = true;
    #           rerere.enabled = true;
    #           pull.autoSquash = true;
    #           push.autoSetupRemote = true;
    #           branch.autosetupmerge = true;
    #           merge.tool = "${lib.getExe pkgs.meld}";
    #           core.excludesfile = "~/.gitignore_global";
    #           push = {
    #             default = "upstream";
    #             useForceIfIncludes = true;
    #           };
    #           diff = {
    #             tool = "vimdiff";
    #             mnemonicprefix = true;
    #           };
    #         };
    #       };

    # TODO: git merger https://meld.app/
  };
}
