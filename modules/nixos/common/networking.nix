{
  lib,
  config,
  globals,
  ...
}:
with lib; {
  options.networking.enable = mkEnableOption "Enable networking settings";

  config = mkIf config.networking.enable {
    networking = {
      networkmanager.enable = true;
      hostName = "${globals.hostname}";

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
    };
  };
}
