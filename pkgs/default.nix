{ pkgs, ... }:
{
  apple-color-emoji = pkgs.callPackage ./apple-color-emoji { };
  catppuccin-supersonic = pkgs.callPackage ./catppuccin-supersonic { };
  cf-terraforming = pkgs.callPackage ./cf-terraforming { };
  languagetool-ff-model = pkgs.callPackage ./languagetool-ff-model { };
  languagetool-ngram-ende = pkgs.callPackage ./languagetool-ngrams { };
  vikunja-desktop = pkgs.callPackage ./vikunja-desktop { };
  waybar-yubikey = pkgs.callPackage ./waybar-yubikey { };
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
}
