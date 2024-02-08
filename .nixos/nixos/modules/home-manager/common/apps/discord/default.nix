{
  pkgs,
  lib,
  ...
}: {
  # TODO: fix this
  imports = [(import ./theme-template.nix)];
  options.discord = {
    enable = lib.mkOption {
      type = lib.type.bool;
      default = false;
      description = "Enable discord overlay";
    };
  };
  config = {
    home.packages = with pkgs; [
      # vesktop
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      # discord
    ];
  };
}
