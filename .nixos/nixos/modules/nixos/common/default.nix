{ pkgs, config, ... }: {
  imports = [
    ./packages.nix
    ./networking.nix
    ./audio.nix
    ./dictionaries.nix
    ./graphical.nix
    ./documentation.nix
    ./keyboard.nix
    # ./virtualisation.nix
  ];
}