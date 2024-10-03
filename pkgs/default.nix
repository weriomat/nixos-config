{pkgs, ...}: {
  starship-catppuccin = pkgs.callPackage ./starship-catppuccin {};
  weriomat-wallpapers = pkgs.callPackage ./weriomat-wallpapers {};
  apple-emoji = pkgs.callPackage ./apple-color-emoji {};
  # TODO: signal desktop
  # https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/modules/signal.nix
}
