{ pkgs, ... }:
rec {
  catppuccin-supersonic = pkgs.callPackage ./catppuccin-supersonic { };
  waybar-yubikey = pkgs.callPackage ./waybar-yubikey { };
  usbguard-dbus = pkgs.callPackage ./usbguard-dbus { };
  waybar-usbguard-wrapped = pkgs.callPackage ./waybar-usbguard-wrapped { inherit usbguard-dbus; };
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers { };
  apple-color-emoji = pkgs.callPackage ./apple-color-emoji { };
  cf-terraforming = pkgs.callPackage ./cf-terraforming { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
  vikunja-desktop = pkgs.callPackage ./vikunja-desktop { };
  languagetool-ngram-ende = pkgs.callPackage ./languagetool-ngrams { };
  languagetool-ff-model = pkgs.callPackage ./languagetool-ff-model { };
}
