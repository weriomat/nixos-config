# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs }: rec {
  starship-catppuccin = pkgs.callPackage ./starship-catppuccin { };
}
