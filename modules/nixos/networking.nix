{
  lib,
  config,
  globals,
  ...
}:
with lib; let
  cfg = config.networking;
in {
  options.networking = {
    enable = mkEnableOption "Enable networking settings";
    dns.enable = mkEnableOption "Enable dns settings" // {default = true;};
  };

  config = mkIf cfg.enable {
    # DNS resolver
    services.resolved = mkIf cfg.dns.enable {
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
      nameservers = mkIf cfg.dns.enable [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "9.9.9.9#dns.quad9.net"
      ];
      dhcpcd.extraConfig = mkIf cfg.dns.enable "nohook resolv.conf";

      networkmanager = {
        enable = true;
        # dns = "systemd-resolved";
        dns =
          if cfg.dns.enable
          then lib.mkForce "none"
          else "default"; # NOTE: tell nm not to touch /etc/resolv.conf
        wifi.powersave = true;
      };

      hostName = "${globals.hostname}";
      useNetworkd = true;
      # TODO: dont use iptables...

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
    };
  };
}
