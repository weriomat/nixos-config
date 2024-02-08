# stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/mako/default.nix
{lib, ...}: {
  options.my_mako = {
    enable = lib.mkOption {
      type = lib.type.bool;
      default = false;
      description = "Enable mako notifications";
    };
  };
  config = {
    services = {
      mako = {
        enable = true;
        font = "JetBrainsMono Nerd Font 12";
        padding = "15";
        defaultTimeout = 5000;
        borderSize = 2;
        borderRadius = 5;
        backgroundColor = "#1e1e2e";
        borderColor = "#b4befe";
        progressColor = "over #313244";
        textColor = "#cdd6f4";
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
