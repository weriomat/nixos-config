# TODO: here
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
  # TODO: switch to mpv
  # https://kokomins.wordpress.com/2019/10/14/mpv-config-guide/
  # https://www.reddit.com/r/mpv/comments/16nlrjh/new_quality_profiles_have_been_added_to_mpv/
  # https://github.com/search?q=repo%3AFrost-Phoenix%2Fnixos-config%20imv&type=code
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/security-services.nix
  # https://home-manager-options.extranix.com/?query=mpv&release=release-24.11
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/home/.config/hypr/hyprland.conf
  # https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/rust.nix
  # https://github.com/ivankovnatsky/nixos-config/blob/main/machines/beelink/journald.nix
  # https://github.com/lpdkt/noise/blob/main/modules/home/programs/mpv.nix
  # https://celluloid-player.github.io/
  # https://github.com/niksingh710/ndots/blob/master/modules/home/nixos/mpv.nix
  # https://github.com/stax76/awesome-mpv
  # https://github.com/lpdkt/noise/blob/main/modules/home/programs/mpv.nix
  # https://github.com/Vladimir-csp/uwsm?tab=readme-ov-file
  # https://github.com/KaylorBen/nixcord
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

  # TODO: nsxiv, pqiv as viewers
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

  # TODO: ics to calendar?
  # TODO: to rss with rss reader
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
    home = {
      sessionVariables = {
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
      packages = [
        pkgs.evince
        pkgs.celluloid
      ];
    };


    # xdg.mimeApps = {
    #   enable = true;
    #   defaultApplications = {
    #     "x-scheme-handler/http" = "firefox.desktop";
    #     "x-scheme-handler/https" = "firefox.desktop";
    #     "x-scheme-handler/chrome" = "firefox.desktop";
    #     "text/html" = "firefox.desktop";
    #   };
    # };
    # TODO: here
    # xdg.desktopEntries.thunderbird = {
    #   name = "Thunderbird";
    #   exec = "thunderbird %U";
    #   terminal = false;
    #   categories = ["Application" "Network" "Chat" "Email"];
    #   mimeType = ["message/rfc822" "x-scheme-handler/mailto" "text/calendar" "text/x-vcard"];
    # };
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

    # TODO: here
    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    #   config = {
    #     common.default = [ "gtk" ];
    #     hyprland.default = [
    #       "gtk"
    #       "hyprland"
    #     ];
    #     #     common.default = ["hyprland"];
    #     #     hyprland.default = ["gtk" "hyprland"];
    #   };
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     #     xdg-desktop-portal-hyprland
    #   ];
    # };

    # TODO: here
    # pgcli # modern postgres client

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

    # programs.mpv = {
    #   enable = true;
    #   config = {
    #     hwdec = "auto-safe";
    #     vo = "gpu";
    #     osc = "no";
    #     border = "no";
    #     profile = "gpu-hq";
    #     gpu-context = "wayland";
    #     force-window = true;
    #     ytdl-format = "bestvideo+bestaudio";
    #   };
    # };

    # TODO: img viewer
    #  programs.pqiv = {
    #   enable = true;
    #   settings = {
    #     options = {
    #       box-colors =
    #         "#${config.lib.stylix.colors.base00}:#${config.lib.stylix.colors.base0F}";
    #       disable-backends = "archive,archive_cbx,libav,poppler,spectre,wand";
    #       hide-info-box = 1;
    #       max-depth = 1;
    #       transparent-background = 1;
    #       window-position = "off";
    #     };
    #   };
    #   extraConfig = ''
    #     [keybindings]
    #       <Control><period>       { animation_continue()                }
    #       <Alt><KP_Subtract>      { animation_set_speed_relative(0.9)   }
    #       <Alt><minus>            { animation_set_speed_relative(0.9)   }
    #       <Alt><KP_Add>           { animation_set_speed_relative(1.1)   }
    #       <Alt><plus>             { animation_set_speed_relative(1.1)   }
    #       <period>                { animation_step(1)                   }
    #       <Control>t              { clear_marks()                       }
    #       h                       { flip_horizontally()                 }
    #       v                       { flip_vertically()                   }
    #       <Control>p              { goto_earlier_file()                 }
    #       p                       { goto_file_relative(-1)              }
    #       <Control>d              { goto_file_relative(-3)              }
    #       n                       { goto_file_relative(1)               }
    #       <Control>u              { goto_file_relative(3)               }
    #       P                       { goto_logical_directory_relative(-1) }
    #       N                       { goto_logical_directory_relative(1)  }
    #       <Control>a              { hardlink_current_image()            }
    #       /                       { jump_dialog()                       }
    #       <space>                 { montage_mode_enter()                }
    #       1                       { numeric_command(1)                  }
    #       2                       { numeric_command(2)                  }
    #       3                       { numeric_command(3)                  }
    #       4                       { numeric_command(4)                  }
    #       5                       { numeric_command(5)                  }
    #       6                       { numeric_command(6)                  }
    #       7                       { numeric_command(7)                  }
    #       8                       { numeric_command(8)                  }
    #       9                       { numeric_command(9)                  }
    #       <Escape>                { quit()                              }
    #       q                       { quit()                              }
    #       <Alt>r                  { reload()                            }
    #       0                       { reset_scale_level()                 }
    #       R                       { rotate_left()                       }
    #       r                       { rotate_right()                      }
    #       <KP_Subtract>           { set_scale_level_relative(0.9)       }
    #       <minus>                 { set_scale_level_relative(0.9)       }
    #       <KP_Add>                { set_scale_level_relative(1.1)       }
    #       <plus>                  { set_scale_level_relative(1.1)       }
    #       <Control><KP_Subtract>  { set_slideshow_interval_relative(-1) }
    #       <Control><minus>        { set_slideshow_interval_relative(-1) }
    #       <Control><KP_Add>       { set_slideshow_interval_relative(1)  }
    #       <Control><plus>         { set_slideshow_interval_relative(1)  }
    #       l                       { shift_x(-10)                        }
    #       h                       { shift_x(10)                         }
    #       j                       { shift_y(-10)                        }
    #       k                       { shift_y(10)                         }
    #       b                       { toggle_background_pattern(0)        }
    #       f                       { toggle_fullscreen(0)                }
    #       i                       { toggle_info_box()                   }
    #       t                       { toggle_mark()                       }
    #       <Control>n              { toggle_negate_mode(0)               }
    #       z                       { toggle_scale_mode(0)                }
    #       <Control>z              { toggle_scale_mode(4)                }
    #       <Alt>z                  { toggle_scale_mode(5)                }
    #       <Control>r              { toggle_shuffle_mode(0)              }
    #       s                       { toggle_slideshow()                  }

    #       @MONTAGE {
    #       <Control>t  { clear_marks() }
    #                G  { goto_file_byindex(-1) }
    #               gg  { goto_file_byindex(0) }
    #                f  { montage_mode_follow(asdfghjkl) }
    #         <Escape>  { montage_mode_return_cancel() }
    #         <Return>  { montage_mode_return_proceed() }
    #                h  { montage_mode_shift_x(-1) }
    #                l  { montage_mode_shift_x(1) }
    #                k  { montage_mode_shift_y(-1) }
    #                j  { montage_mode_shift_y(1) }
    #       <Control>u  { montage_mode_shift_y_pg(-1) }
    #       <Control>d  { montage_mode_shift_y_pg(1) }
    #       <Mouse-Scroll-2>  { montage_mode_shift_y_rows(-1) }
    #       <Mouse-Scroll-1>  { montage_mode_shift_y_rows(1) }
    #                q  { quit() }
    #                t  { toggle_mark() }
    #       }    '';
    # };

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
    # TODO: Video viewer
    # programs.mpv = {
    #      enable = true;
    #      bindings = {
    #        l = "seek 20";
    #        h = "seek -20";
    #        "]" = "add speed 0.1";
    #        "[" = "add speed -0.1";
    #        j = "seek -4";
    #        k = "seek 4";
    #        K = "cycle sub";
    #        J = "cycle sub down";
    #        w = "add sub-pos -10"; # move subtitles up
    #        W = "add sub-pos -1"; # move subtitles up
    #        e = "add sub-pos +10"; # move subtitles down
    #        E = "add sub-pos +1"; # move subtitles down
    #        "=" = "add sub-scale +0.1";
    #        "-" = "add sub-scale -0.1";
    #      };

    #      config = {
    #        speed = 1;
    #        hwdec = true;
    #        sub-pos = 90;
    #        keep-open = true;
    #        sub-auto = "all";
    #        sub-font-size = 40;
    #        sub-border-size = 2;
    #        sub-shadow-offset = 2;
    #        sub-visibility = "yes";
    #        sub-ass-line-spacing = 1;
    #        sub-ass-hinting = "normal";
    #        sub-ass-override = "force";
    #        save-position-on-quit = true;
    #        sub-auto-exts = "srt,ass,txt";
    #        ytdl-format = "bestvideo+bestaudio/best";
    #        slang = "fin,fi,fi-fi,eng,en,en-en,en-orig";
    #        sub-font = "${config.stylix.fonts.serif.name}";
    #        sub-ass-force-style = "${config.stylix.fonts.serif.name}";
    #        sub-color = "${config.lib.stylix.colors.withHashtag.base07}";
    #        sub-shadow-color = "${config.lib.stylix.colors.withHashtag.base00}";
    #        watch-later-options-clr = true; # Dont save settings like brightness
    #      };
    #      scripts = [
    #        pkgs.mpvScripts.uosc
    #        pkgs.mpvScripts.acompressor
    #      ];
    #    };

    # TODO: take a look at moar as a pager, https://github.com/walles/moar
    # from https://github.com/saygo-png/nixos/blob/main/configuration.nix
    # # Prevent default apps from being changed
    #     xdg.configFile."mimeapps.list".force = true;
    #     xdg.mimeApps = {
    #       enable = true;
    #       associations.added = config.xdg.mimeApps.defaultApplications;
    #       defaultApplications = let
    #         inherit (config.home.sessionVariables) EDITOR;
    #         inherit (config.home.sessionVariables) BROWSER;
    #       in {
  };
}
