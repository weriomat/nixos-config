{ pkgs, ... }:
rec {
  apple-color-emoji = pkgs.callPackage ./apple-color-emoji { };
  catppuccin-supersonic = pkgs.callPackage ./catppuccin-supersonic { };
  cf-terraforming = pkgs.callPackage ./cf-terraforming { };
  languagetool-ff-model = pkgs.callPackage ./languagetool-ff-model { };
  languagetool-ngram-ende = pkgs.callPackage ./languagetool-ngrams { };
  usbguard-dbus = pkgs.callPackage ./usbguard-dbus { };
  vja = pkgs.callPackage ./vja { };
  waybar-usbguard-wrapped = pkgs.callPackage ./waybar-usbguard-wrapped { inherit usbguard-dbus; };
  waybar-yubikey = pkgs.callPackage ./waybar-yubikey { };
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
}
