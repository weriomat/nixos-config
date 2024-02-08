# { config, pkgs, inputs, outputs ... }:
{pkgs, ...}: {
  imports = [./apps/default_laptop.nix];

  discord.enable = true;
  firefox.enable = true;
  home = {
    username = "marts";
    homeDirectory = "/home/marts";
    stateVersion = "23.11";
    packages =
      builtins.attrValues (import ./scripts/scripts.nix {inherit pkgs;});
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
