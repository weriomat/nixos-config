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

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      firewall = {
        enable = true;
        checkReversePath = "loose";
      };

      # wireless.enable = true; # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };
}
