{ pkgs, ... }:
{
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers { };
  apple-color-emoji = pkgs.callPackage ./apple-color-emoji { };
  cf-terraforming = pkgs.callPackage ./cf-terraforming { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
  vikunja-desktop = pkgs.callPackage ./vikunja-desktop { };
  languagetool-ngram-ende = pkgs.callPackage ./languagetool-ngrams { };
  languagetool-ff-model = pkgs.callPackage ./languagetool-ff-model { };
  # TODO: signal desktop
  # https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/modules/signal.nix
}
