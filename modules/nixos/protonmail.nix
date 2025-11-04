{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.services.pmail;
in
{
  options.services.pmail.enable = mkEnableOption "protonmail with gnome";

  config = mkIf cfg.enable {
    services.keyring.enable = true;

    # an alternative would be `pkgs.protonmail-bridge-gui`
    services.protonmail-bridge = {
      enable = true; # manual setup, combined address mode
      path = [ pkgs.gnome-keyring ]; # we need this in path such that the vault will not get wiped every restart
    };
  };
}
