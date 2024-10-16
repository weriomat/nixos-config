# TODO: here
# https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/xdg-mimes.nix
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
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/chrome" = "firefox.desktop";
  #     "text/html" = "firefox.desktop";
  #   };
  # };
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

  # TODO: here
  # xdg.userDirs = {
  #   enable = true;
  #   documents = "$HOME/stuff/other/";
  #   download = "$HOME/stuff/other/";
  #   videos = "$HOME/stuff/other/";
  #   music = "$HOME/stuff/music/";
  #   pictures = "$HOME/stuff/pictures/";
  #   desktop = "$HOME/stuff/other/";
  #   publicShare = "$HOME/stuff/other/";
  #   templates = "$HOME/stuff/other/";
  # };
  # home.packages = with pkgs; [ffmpegthumbnailer];

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

  # xdg.mimeApps.defaultApplications = {
  #   "video/mp4" = "mpv.desktop";
  #   "video/x-matroska" = "mpv.desktop";
  #   "video/webm" = "mpv.desktop";
  #   "video/quicktime" = "mpv.desktop";
  #   "video/x-msvideo" = "mpv.desktop";
  #   "video/x-ms-wmv" = "mpv.desktop";
  #   "video/x-flv" = "mpv.desktop";
  #   "video/x-m4v" = "mpv.desktop";
  #   "video/3gpp" = "mpv.desktop";
  #   "video/3gpp2" = "mpv.desktop";
  #   "video/x-matroska-3d" = "mpv.desktop";
  #   "video/x-ms-asf" = "mpv.desktop";
  #   "video/x-ms-wvx" = "mpv.desktop";
  #   "video/x-ms-wmx" = "mpv.desktop";
  #   "video/x-ms-wm" = "mpv.desktop";
  #   "video/x-ms-wmp" = "mpv.desktop";
  #   "video/x-ms-wmz" = "mpv.desktop";
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

  # xdg.mimeApps.defaultApplications = {
  #   "image/jpeg" = "pqiv.desktop";
  #   "image/gif" = "pqiv.desktop";
  #   "image/webp" = "pqiv.desktop";
  #   "image/png" = "pqiv.desktop";
  #   "image/svg+xml" = "pqiv.desktop";
  # };

  # TODO: pdfviewer
  # programs.zathura = {
  #   enable = true;
  #   extraConfig = ''
  #     set window-title-home-tilde true
  #     set statusbar-basename true
  #     set selection-clipboard clipboard

  #     set scroll-page-aware "true"
  #     set scroll-full-overlap 0.01
  #     set scroll-step 100

  #     set statusbar-h-padding 0
  #     set statusbar-v-padding 0
  #     set page-padding 1
  #     set database "sqlite"

  #     map u scroll half-up
  #     map d scroll half-down
  #     map D toggle_page_mode
  #     map R reload
  #     map r rotate
  #     map J zoom in
  #     map K zoom out
  #     map i recolor
  #     set recolor true
  #   '';
  # };

  # xdg.mimeApps.defaultApplications = {
  #   "application/pdf" = "zathura.desktop";
  #   "application/vnd.ms-powerpoint" = "zathura.desktop";
  # };
}
