{
  lib,
  config,
  globals,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.firefox;
in
{
  imports = [
    ./extensions.nix
    ./search.nix
    ./bookmarks.nix
  ];

  options.firefox = {
    enable = mkEnableOption "Enable firefox config";
    arkenfox.enable = mkEnableOption "Enable arkenfox";
  };

  config = mkIf cfg.enable {
    catppuccin.firefox = {
      enable = true;
      force = true;
      accent = "mauve";
      flavor = "mocha";
      profiles.${globals.username} = {
        enable = true;
        force = true;
        accent = "mauve";
        flavor = "mocha";
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod SHIFT, M, exec, ${config.programs.firefox.finalPackage}/bin/firefox"
      ];
      windowrule = [
        "opaque, class:^(firefox)"
        "float,title:^(Firefox — Sharing Indicator)$"
        "move 0 0,title:^(Firefox — Sharing Indicator)$"
      ];
      windowrulev2 = [
        # idleinhibit
        "idleinhibit fullscreen, class:^(firefox)$"
        "idleinhibit focus, class:^(firefox)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];
    };

    home.sessionVariables.BROWSER = "firefox";

    programs.firefox = {
      enable = true;

      arkenfox = mkIf cfg.arkenfox.enable {
        enable = true;
        version = "master";
      };

      profiles.${globals.username} = {
        # potentially problematic: 0703, 0820 (color visited links)
        # see: nix build "github:dwarfmaster/arkenfox-nixos#arkenfox-v103_0-doc-static" && firefox result
        # TODO: here
        arkenfox = mkIf cfg.arkenfox.enable {
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
          "toolkit.telemetry.newprofileping.enabled" = false;
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
