{ pkgs, ... }:
{
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers { };
  apple-emoji = pkgs.callPackage ./apple-color-emoji { };
  cf-terraforming = pkgs.callPackage ./cf-terraforming { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
  # TODO: signal desktop
  # https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/modules/signal.nix
}
