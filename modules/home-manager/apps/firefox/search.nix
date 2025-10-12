{
  config,
  lib,
  globals,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.firefox;
in
{
  config = mkIf cfg.enable {
    programs.firefox.profiles.${globals.username}.search = {
      force = true;
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
    };
  };
}
