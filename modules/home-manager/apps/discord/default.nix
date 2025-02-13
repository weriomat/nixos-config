{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  # TODO: fix this
  # imports = [ (import ./theme-template.nix) ];
  options.discord.enable = mkEnableOption "Enable discord overlay";

  config = mkIf config.discord.enable {
    home.packages = [
      # vesktop
      # https://github.com/Goxore/nixconf/blob/main/homeManagerModules/features/vesktop.nix
      # TODO: catppucin, catppuccin-discord https://github.com/NixOS/nixpkgs/pull/365773/commits/db285865f73b3214f13536c32aa729bb4de77baa
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      # discord
    ];
  };
}
