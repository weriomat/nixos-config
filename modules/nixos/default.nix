{ ... }:
{
  imports = [
    ./audio.nix
    ./dictionaries.nix
    ./documentation.nix
    ./fonts.nix
    ./flatpak.nix
    ./graphical.nix
    ./keyboard.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./virtualisation.nix
    ./languagetool.nix
    ./user.nix
    ./steam.nix
    ./security.nix
    ./borg.nix
    ./sops.nix

    # TODO: here
    ./smartd.nix
  ];
}
