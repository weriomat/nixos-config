{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  # TODO: fix this
  imports = [(import ./theme-template.nix)];
  options.discord.enable = mkEnableOption "Enable discord overlay";

  config = mkIf config.discord.enable {
    home.packages = with pkgs; [
      # vesktop
      # https://github.com/Goxore/nixconf/blob/main/homeManagerModules/features/vesktop.nix
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      # discord
    ];
  };
}
