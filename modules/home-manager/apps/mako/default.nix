# stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/mako/default.nix
{
  lib,
  config,
  ...
}:
with lib; {
  options.my_mako.enable = mkEnableOption "Enable mako notifications";

  config = mkIf config.my_mako.enable {
    services.mako = {
      enable = true;

      catppuccin = {
        enable = true;
        flavor = "mocha";
      };

      # TODO: font here
      font = "JetBrainsMono Nerd Font 12";
      padding = "15";
      defaultTimeout = 5000;
      borderSize = 2;
      borderRadius = 5;
      icons = true;
      actions = true;
      extraConfig = ''
        text-alignment=center
        [urgency=high]
        border-color=#fab387
      '';
    };
  };
}
