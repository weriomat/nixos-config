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
    # NOTE: this gets enabled at startup by dbus through `pkgs.mako/share/dbus-1/services/fr.emersion.mako.service`
    services.mako = {
      enable = true;

      catppuccin = {
        enable = true;
        flavor = "mocha";
      };

      # TODO: font here, pango format
      font = "JetBrainsMono Nerd Font 12";
      # TODO: icon paths
      # services.mako.iconPath
      padding = "15";
      defaultTimeout = 5000;
      borderSize = 2;
      borderRadius = 5;
      icons = true;
      actions = true;
      extraConfig = ''
        text-alignment=center
        [urgency=high]
        border-color=#${config.colorScheme.palette.base09}
      '';
    };
  };
}
