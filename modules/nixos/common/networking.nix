{
  lib,
  config,
  globals,
  options,
  ...
}: {
  options.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable networking settings";
    };
  };
  config = lib.mkIf config.networking.enable {
    # TODO: here
    # networking = {
    #   # use quad9 with DNS over TLS
    #   nameservers = ["9.9.9.9#dns.quad9.net"];

    #   networkmanager = {
    #     enable = true;
    #     dns = "systemd-resolved";
    #     wifi.powersave = true;
    #   };
    # };

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

    networking = {
      networkmanager.enable = true;
      hostName = "${globals.hostname}";
      timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
      firewall = {
        enable = true;
        checkReversePath = "loose";
      };
    };
  };
}
