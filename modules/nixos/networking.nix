{
  lib,
  config,
  globals,
  ...
}:
with lib; {
  options.networking.enable = mkEnableOption "Enable networking settings";

  config = mkIf config.networking.enable {
    # services = {
    #   openssh = {
    #     enable = true;
    #     settings.UseDns = true;
    #   };

    #   # DNS resolver
    #   resolved = {
    #     enable = true;
    #     dnsovertls = "opportunistic";
    #   };
    # };

    # TODO: intrd. has same optino
    # NOTE: dont wait for network to be online while booting
    systemd.network = {
      wait-online.enable = false;
      enable = true;
    };

    # TODO: maybe own dns server/ own caching
    networking = {
      # TODO: here
      # use quad9 with DNS over TLS
      # nameservers = ["9.9.9.9#dns.quad9.net"];

      networkmanager = {
        enable = true;
        # dns = "systemd-resolved";
        # wifi.powersave = true;
      };
      # };
      hostName = "${globals.hostname}";
      useNetworkd = true;
      # timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
    };
  };
}
