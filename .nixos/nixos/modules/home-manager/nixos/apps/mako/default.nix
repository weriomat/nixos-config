# stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/mako/default.nix
{
  lib,
  config,
  ...
}: {
  options.my_mako = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mako notifications";
    };
  };
  config = lib.mkIf (config.my_mako.enable) {
    services = {
      mako = {
        enable = true;
        font = "JetBrainsMono Nerd Font 12";
        padding = "15";
        defaultTimeout = 5000;
        borderSize = 2;
        borderRadius = 5;
        backgroundColor = "#${config.colorScheme.palette.base00}";
        borderColor = "#${config.colorScheme.palette.base07}";
        progressColor = "over #${config.colorScheme.palette.base02}";
        textColor = "#${config.colorScheme.palette.base05}";
        icons = true;
        actions = true;
        extraConfig = ''
          text-alignment=center
          [urgency=high]
          border-color=#fab387
        '';
      };
    };
  };
}
