{
  inputs,
  config,
  lib,
  globals,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf licenses;
  cfg = config.firefox;
in
{
  config = mkIf cfg.enable {
    # TODO: configure,automaticcly accept, set permissions, configure settings, https://mozilla.github.io/policy-templates/
    programs.firefox.profiles.${globals.username}.extensions = {
      force = true;
      packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        # privacy
        ublock-origin
        auto-tab-discard
        canvasblocker
        clearurls
        facebook-container
        decentraleyes
        user-agent-string-switcher

        # ui
        firefox-color
        darkreader
        adaptive-tab-bar-colour
        stylus # for catppuccin userstyles

        # util
        (languagetool.overrideAttrs { meta.license = licenses.free; })
        return-youtube-dislikes
        refined-github # cleaner github interface
        bitwarden
        linkwarden
        zotero-connector

        # unpaywall
        # to-deepl
        # privacy-badger + i-dont-care-about-cookies
        # link-cleaner

        # new
        # censor-tracker # https://censortracker.org/en.html
        # consent-o-matic # https://consentomatic.au.dk/
        # dearrow # https://dearrow.ajay.app/
        # deutsch-de-language-pack
        # dictionary-german

        # foxytab # https://github.com/erosman/support
        # native-mathml # https://github.com/fred-wang/webextension-native-mathml
        # sponsorblock # https://sponsor.ajay.app/
        # web-archives # https://github.com/dessant/web-archives#readme

        # buster-captcha-solver # https://github.com/dessant/buster#readme
        # bypass-paywalls-clean # https://twitter.com/Magnolia1234B
        # vimium # https://github.com/philc/vimium

        # TODO: here

        #    privacy-badger
        # vimium-c
        # simple-translate

        # (enhancer-for-youtube.overrideAttrs {
        #   meta.license = lib.licenses.free;
        # })
      ];

      settings."addon@darkreader.org" = {
        force = true;
        settings = {
          schemeVersion = 2;
          enabled = true;
          fetchNews = true;
          theme = {
            mode = 1;
            brightness = 100;
            contrast = 100;
            grayscale = 0;
            sepia = 0;
            useFont = false;
            fontFamily = "Open Sans";
            textStroke = 0;
            engine = "dynamicTheme";
            stylesheet = "";
            darkSchemeBackgroundColor = "#1e1e2e"; # 181a1b
            darkSchemeTextColor = "#cdd6f4"; # e8e6e3
            lightSchemeBackgroundColor = "#eff1f5"; # dcdad7
            lightSchemeTextColor = "#4c4f69"; # 181a1b
            scrollbarColor = "auto";
            selectionColor = "#585b70"; # auto
            styleSystemControls = false;
            lightColorScheme = "Default";
            darkColorScheme = "Default";
            immediateModify = false;
          };
          presets = [ ];
          customThemes = [ ];
          enabledByDefault = true;
          enabledFor = [ ];
          disabledFor = [ ];
          changeBrowserTheme = false;
          syncSettings = true;
          syncSitesFixes = true; # changed
          automation = {
            enabled = false;
            mode = "";
            behavior = "OnOff";
          };
          time = {
            activation = "18:00";
            deactivation = "9:00";
          };
          location = {
            latitude = null;
            longitude = null;
          };
          previewNewDesign = true; # changed
          previewNewestDesign = false;
          enableForPDF = true; # changed
          enableForProtectedPages = true; # changed
          enableContextMenus = false;
          detectDarkTheme = true; # changed
          displayedNews = [
            "thanks-2023"
          ];
        };
      };
    };
  };

}
