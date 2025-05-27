{
  inputs,
  pkgs,
  lib,
  config,
  globals,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf licenses;
  cfg = config.firefox;
in
{
  options.firefox = {
    enable = mkEnableOption "Enable firefox config";
    arkenfox.enable = mkEnableOption "Enable arkenfox";
  };

  # TODO: https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/shared/default.nix

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod SHIFT, M, exec, ${config.programs.firefox.finalPackage}/bin/firefox"
      ];
      windowrule = [
        #   windowrule = float,title:^(Firefox — Sharing Indicator)$
        #   windowrule = move 0 0,title:^(Firefox — Sharing Indicator)$
        #
        "opaque, class:^(firefox)"
      ];
      windowrulev2 = [
        # idleinhibit
        "idleinhibit fullscreen, class:^(firefox)$"
        "idleinhibit focus, class:^(firefox)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];
    };

    # TODO: take a look at https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
    # TODO: take a look at https://github.com/fufexan/dotfiles/blob/main/home/programs/browsers/firefox.nix
    # TODO: Take a look at https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/programs/firefox/addons.nix
    # TODO: take a look at https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/programs/firefox/default.nix
    # TODO:  fonts
    #   profileSettings = {
    #   settings = {
    #     "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;
    #     "font.name.sans-serif.x-western" = config.stylix.fonts.sansSerif.name;
    #     "font.name.serif.x-western" = config.stylix.fonts.serif.name;
    #   };
    # };

    # TODO: darkreader
    # home.file.".config/darkreader/config.json".text =
    #   # json
    #   ''
    #     {
    #       "schemeVersion": 2,
    #       "enabled": true,
    #       "fetchNews": true,
    #       "theme": {
    #         "mode": 1,
    #         "brightness": 100,
    #         "contrast": 100,
    #         "grayscale": 0,
    #         "sepia": 0,
    #         "useFont": false,
    #         "fontFamily": "Open Sans",
    #         "textStroke": 0,
    #         "engine": "dynamicTheme",
    #         "stylesheet": "",
    #         "darkSchemeBackgroundColor": "#${colors.base00}",
    #         "darkSchemeTextColor": "#${colors.base0F}",
    #         "lightSchemeBackgroundColor": "#${colors.base0F}",
    #         "lightSchemeTextColor": "#${colors.base00}",
    #         "scrollbarColor": "auto",
    #         "selectionColor": "auto",
    #         "styleSystemControls": false,
    #         "lightColorScheme": "Default",
    #         "darkColorScheme": "Default",
    #         "immediateModify": false
    #       },
    #       "presets": [],
    #       "customThemes": [],
    #       "enabledByDefault": true,
    #       "enabledFor": [],
    #       "disabledFor": [],
    #       "changeBrowserTheme": false,
    #       "syncSettings": false,
    #       "syncSitesFixes": true,
    #       "automation": {
    #         "enabled": false,
    #         "mode": "",
    #         "behavior": "OnOff"
    #       },
    #       "time": {
    #         "activation": "18:00",
    #         "deactivation": "9:00"
    #       },
    #       "location": {
    #         "latitude": null,
    #         "longitude": null
    #       },
    #       "previewNewDesign": true,
    #       "enableForPDF": true,
    #       "enableForProtectedPages": true,
    #       "enableContextMenus": false,
    #       "detectDarkTheme": false,
    #       "displayedNews": [
    #         "thanks-2023"
    #       ]
    #     }
    #   '';

    home.sessionVariables.BROWSER = "firefox";
    programs.firefox = {
      enable = true;

      arkenfox = mkIf cfg.arkenfox.enable {
        enable = true;
        version = "master";
      };

      # TODO: languagepacks
      # `https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.languagePacks`

      profiles.${globals.username} = {
        # potentially problematic: 0703, 0820 (color visited links)
        # see: nix build "github:dwarfmaster/arkenfox-nixos#arkenfox-v103_0-doc-static" && firefox result
        arkenfox = mkIf cfg.arkenfox.enable {
          # TODO: here
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0200".enable = true;
          "0300".enable = true;
          "0600".enable = true;
          "0700".enable = true;
          "0800" = {
            enable = true;
            # "0804"."browser.search.suggest.enabled".value = true;
            # "0804"."urlbar.suggest.searches".value = true;
          };
          "0900".enable = true;
          "1200".enable = true;
          # "1400".enable = true;
          "1600".enable = true;
          "1700".enable = true;
          "2000".enable = true;
          "2400".enable = true;
          # "2600" = {
          # "2601".enable = true;
          #   "2602".enable = true;
          #   "2607".enable = true;
          #   "2608".enable = true;
          #   "2615".enable = true;
          #   "2616".enable = true;
          #   "2619".enable = true;
          #   "2623".enable = true;
          #   "2651".enable = true;
          #   "2652".enable = true;
          #   "2654".enable = true;
          #   "2661".enable = true;
          #   "2662".enable = true;
          # };
          "2700".enable = true;
          "4500".enable = true;
          "5000"."5003".enable = true;
          "6000".enable = true;
          "7000".enable = true;
          "8000".enable = true;
        };

        bookmarks = [
          {
            name = "Home-Manager Wiki";
            tags = [ "wiki" ];
            keyword = "homemanager";
            url = "https://nix-community.github.io/home-manager/options.xhtml";
          }
          {
            name = "Nix - A One Pager -> Nix Language";
            tags = [ "wiki" ];
            keyword = "nix";
            url = "https://github.com/tazjin/nix-1p";
          }
          {
            name = "nixos-manual";
            tags = [ "wiki" ];
            keyword = "nixos";
            url = "https://nixos.org/manual/nix/stable/introduction";
          }
          {
            name = "NixOS - Book";
            tags = [ "Books" ];
            keyword = "nixbook";
            url = "https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration";
          }
          {
            name = "Install guide of steam";
            tags = [ "wiki" ];
            keyword = "steam";
            url = "https://jmglov.net/blog/2022-06-20-installing-steam-on-nixos.html";
          }
          {
            name = "rust flake";
            tags = [ "rust" ];
            url = "https://www.tweag.io/blog/2022-09-22-rust-nix/";
          }
          {
            name = "rust flake with hercules ci";
            tags = [ "rust" ];
            url = "https://github.com/cpu/rust-flake/blob/main/README.md";
          }
          {
            name = "noogle";
            toolbar = true;
            bookmarks = [
              {
                name = "noogle";
                tags = [ "nix" ];
                url = "https://noogle.dev/";
              }
            ];
          }
          {
            name = "Utils";
            toolbar = true;
            bookmarks = [
              {
                name = "Chmod calc";
                url = "https://chmod-calculator.com/";
              }
              {
                name = "Nixhub";
                url = "https://www.nixhub.io/";
              }
              {
                name = "gpg cheat-sheet";
                url = "https://gock.net/blog/2020/gpg-cheat-sheet";
              }
            ];
          }
          {
            name = "Grafana - Dashboard";
            toolbar = true;
            bookmarks = [
              {
                name = "dashboard raspi doc";
                url = "https://github.com/rfmoz/grafana-dashboards";
              }
            ];
          }
          {
            name = "Rust";
            toolbar = true;
            bookmarks = [
              {
                name = "rust programming lang book";
                url = "https://doc.rust-lang.org/stable/book/";
              }
            ];
          }
          {
            name = "Category Theory";
            toolbar = true;
            bookmarks = [
              {
                name = "Stanford summary";
                url = "https://plato.stanford.edu/entries/category-theory/";
              }
              {
                name = "auburn summary";
                url = "https://web.auburn.edu/holmerr/8970/Textbook/CategoryTheory.pdf";
              }
              {
                name = "ucsb script";
                url = "https://web.math.ucsb.edu/~atrisal/category%20theory.pdf";
              }
              {
                name = "Standford book recommendations";
                url = "https://plato.stanford.edu/entries/category-theory/bib.html";
              }
            ];
          }
        ];

        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          darkreader
          auto-tab-discard
          canvasblocker
          clearurls
          # add capuccin colors to firefox-color -> manual idk how to do that in nix
          # enable dark theme in about:addons under themes
          firefox-color
          facebook-container
          decentraleyes
          return-youtube-dislikes
          user-agent-string-switcher

          # rss stuff
          # rsshub-radar # finds RSSHub stuff

          # passwords
          bitwarden

          # links
          linkwarden

          # new
          censor-tracker # https://censortracker.org/en.html
          consent-o-matic # https://consentomatic.au.dk/
          dearrow # https://dearrow.ajay.app/
          deutsch-de-language-pack
          dictionary-german

          enhanced-github # https://github.com/softvar/enhanced-github
          foxytab # https://github.com/erosman/support
          h264ify
          native-mathml # https://github.com/fred-wang/webextension-native-mathml
          sponsorblock # https://sponsor.ajay.app/
          web-archives # https://github.com/dessant/web-archives#readme

          buster-captcha-solver # https://github.com/dessant/buster#readme
          # bypass-paywalls-clean # https://twitter.com/Magnolia1234B
          vimium # https://github.com/philc/vimium

          # TODO: here
          (languagetool.overrideAttrs { meta.license = licenses.free; })
          # languagetool # https://languagetool.org/  https://github.com/nschang/languagetool-101

          zotero-connector

          #    privacy-badger
          # vimium-c
          # gloc
          # adaptive-tab-bar-colour
          # unpaywall
          # simple-translate

          # # NOTE: Hacky solution here will change when get time
          # (languagetool.overrideAttrs { meta.license = lib.licenses.free; })
          # (tampermonkey.overrideAttrs { meta.license = lib.licenses.free; })
          # (enhancer-for-youtube.overrideAttrs {
          #   meta.license = lib.licenses.free;
          # })
        ];
        search = {
          default = "ddg";
          privateDefault = "ddg";
          engines = {
            "steam" = {
              urls = [ { template = "https://store.steampowered.com/search/?term={searchTerms}"; } ];
              definedAliases = [ "@steam" ];
            };
            "youtube" = {
              urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
              definedAliases = [
                "@yt"
                "@y"
              ];
            };
            "Crates" = {
              urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
              definedAliases = [ "@rc" ];
            };
            "Rust-Doc" = {
              urls = [ { template = "https://docs.rs/{searchTerms}"; } ];
              definedAliases = [ "@rd" ];
            };
            "Noogle" = {
              urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
              definedAliases = [ "@n" ];
            };
            "Nixhub" = {
              urls = [ { template = "https://www.nixhub.io/search?q={searchTerms}"; } ];
              definedAliases = [ "@nix" ];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@o" ];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "ProtonDB" = {
              urls = [ { template = "https://www.protondb.com/search?q={searchTerms}"; } ];
              definedAliases = [ "@pd" ];
            };
            "NixOS Wiki" = {
              urls = [
                { template = "https://wiki.nixos.org/w/index.php?title=Special:Search&search={searchTerms}"; }
              ];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Home Manager Options" = {
              urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
              definedAliases = [ "@hm" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "bing".metaData.hidden = true;
            "google".metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "ebay".metaData.hidden = true;
          };
          force = true;
        };

        settings = {
          # hw accel
          "media.ffmpeg.vaapi.enabled" = true;
          # widevine drm
          "media.gmp-widevinecdm.enabled" = true;

          # disable firefox dns stuff
          "network.trr.mode" = 5;

          "browser.search.region" = "US";
          "browser.search.isUS" = true;
          "distribution.searchplugins.defaultLocale" = "en-US";
          "general.useragent.locale" = "en-US";
          "browser.newtabpage.pinned" = [
            {
              title = "Search NixOS";
              url = "https://search.nixos.org/packages";
            }
            {
              title = "Search Home Manager";
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
          ];
          # settings for hardening firefox
          # "media.peerconnection.enabled" = false;
          "privacy.resistFingerprinting" = true;
          "security.ssl3.rsa_des_ede3_sha" = false;
          "security.ssl.require_safe_negotiation" = true;
          "security.tls.version.min" = 3;
          "security.tls.version.max" = 4;
          "security.tls.enable_0rtt_data" = false;
          "browser.formfil.enable" = false;
          # -> no history
          # browser.cache.disk.enable = false
          # browser.cache.disk_cache_ssl = false;
          # browser.cache.memory.enable = false;
          # browser.cache.offline.enable = false
          # browser.cache.insecure.enable = false;
          "geo.enabled" = false;
          "plugin.scan.plid.all" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.pingcentre.telemetry" = false;
          "devtools.onboarding.telemetry-logged" = false;
          "media.wmf.deblacklisting-for-telemetry-in-gpu-process" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridcontent.enabled" = false;
          "toolkit.telementry.newprofileping.enabled" = false;
          "toolkit.telemetry.unified.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "webgl.disabled" = true;
          "security.ssl.enable_false_start" = false;

          # wayland
          "media.peerconnection.enabled" = true;

          # pocket
          "extensions.pocket.enabled" = false;

          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # arkenfox conflikt
          # "privacy.firstparty.isolate" = true; # WHY
          # "browser.startup.homepage" = "https://duckduckgo.com";
        };
      };
    };
  };
}
