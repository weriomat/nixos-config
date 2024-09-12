# stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/mako/default.nix
{
  config,
  lib,
  ...
}:
with lib; {
  options.mako.enable = mkEnableOption "Enable mako notifications";

  config = mkIf config.mako.enable {
    wayland.windowManager.hyprland.settings.exec-once = ["mako &"];

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
