{
  pkgs,
  lib,
  config,
  ...
}: {
  # TODO: fix this
  imports = [(import ./theme-template.nix)];
  options.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable discord overlay";
    };
  };
  config = lib.mkIf config.discord.enable {
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
