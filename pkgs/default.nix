{pkgs, ...}: {
  starship-catppuccin = pkgs.callPackage ./starship-catppuccin {};
  # TODO: switch to pkgs.callPackage
  weriomat-wallpapers = import ./weriomat-wallpapers {inherit pkgs;};
  # TODO: here
  # apple-emoji = import ./apple-color-emoji {inherit pkgs;};
  # TODO: signal desktop
  # https://github.com/gvolpe/nix-config/blob/b9ff455faaf5a4890985305e5c7a5a01606d20f3/home/modules/signal.nix
}
