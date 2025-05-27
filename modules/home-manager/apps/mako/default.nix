# stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/mako/default.nix
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.mako.enable = mkEnableOption "Enable mako notifications";

  config = mkIf config.mako.enable {
    catppuccin.mako = {
      enable = true;
      flavor = "mocha";
    };

    # NOTE: this gets enabled at startup by dbus through `pkgs.mako/share/dbus-1/services/fr.emersion.mako.service`
    services.mako = {
      enable = true;

      settings = {
        padding = "15";
        default-timeout = 5000;
        border-size = 2;
        border-radius = 5;
        icons = true;
        actions = true;
        text-alignment = "center";
        # urgency = "high";
      };
    };
  };
}
