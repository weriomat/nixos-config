{pkgs, ...}: {
  starship-catppuccin = pkgs.callPackage ./starship-catppuccin {};
  # TODO: switch to pkgs.callPackage
  weriomat-wallpapers = import ./weriomat-wallpapers {inherit pkgs;};
}
