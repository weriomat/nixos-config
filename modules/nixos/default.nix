{ ... }:
{
  imports = [
    ./audio.nix
    ./borg.nix
    ./dictionaries.nix
    ./documentation.nix
    ./flatpak.nix
    ./fonts.nix
    ./graphical.nix
    ./keyboard.nix
    ./languagetool.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./sops.nix
    ./steam.nix
    ./usbguard-notifier.nix
    ./user.nix
    ./virtualisation.nix

    # TODO: here
    ./smartd.nix
  ];
}
