{ pkgs, lib, inputs, ... }: {
  # TODO: add arkenfox/user.js to config
  # firefox config -> vimjoyer video
  programs.firefox = {
    enable = true;
    profiles.marts = {
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
          url =
            "https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration";
        }

      ];
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
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
        keepassxc-browser
        return-youtube-dislikes
        user-agent-string-switcher
      ];
      search = {
        default = "DuckDuckGo";
        engines = {
          "Nix Packages" = {
            urls = [{
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
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "Home Manager Options" = {
            urls = [{
              template = "https://mipmip.github.io/home-manager-option-search/";
            }];
            definedAliases = [ "@hm" ];
          };
        };
        force = true;
      };

      settings = {
        "browser.startup.homepage" = "https://duckduckgo.com";
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
        "media.peerconnection.enabled" = false;
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
        "privacy.firstparty.isolate" = true;
        "security.ssl.enable_false_start" = false;
      };
    };
  };

}
