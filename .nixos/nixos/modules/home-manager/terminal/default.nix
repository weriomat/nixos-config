{ pkgs, ... }: {
  imports = [
    ./btop
    ./helix
    ./kitty
    ./zsh
    ./ssh
    ./lazygit
    ./usefulPackages.nix
    ./eza
    ./starship
  ];
}
