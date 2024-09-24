{
  lib,
  config,
  globals,
  ...
}:
with lib; {
  options.networking.enable = mkEnableOption "Enable networking settings";

  config = mkIf config.networking.enable {
    # DNS resolver
    services.resolved = {
      enable = true;
      dnsovertls = "true";
      dnssec = "false";
      domains = ["~."];
      fallbackDns = config.networking.nameservers;
    };

    # NOTE: dont wait for network to be online while booting
    systemd.network = {
      enable = true;
      wait-online.enable = false;
    };

    networking = {
      # NOTE: DoT -> `https://shivering-isles.com/2021/01/configure-dot-on-systemd-resolved`
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "9.9.9.9#dns.quad9.net"
      ];
      dhcpcd.extraConfig = "nohook resolv.conf";

      networkmanager = {
        enable = true;
        # dns = "systemd-resolved";
        dns = lib.mkForce "none"; # NOTE: tell nm not to touch /etc/resolv.conf
        wifi.powersave = true;
      };

      hostName = "${globals.hostname}";
      useNetworkd = true;

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
    };
  };
}
