# { pkgs, inputs, outputs, ... }: {
{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./helix.nix
    ./kitty.nix
    ./zsh.nix
    ./ssh.nix
    ./lazygit.nix
    ./usefulPackages.nix
    ./eza.nix
    ./starship.nix
  ];
}
