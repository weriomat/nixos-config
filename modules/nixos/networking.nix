{
  lib,
  config,
  globals,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.networking;
in
{
  # TODO: swithc to networkd? https://github.com/timon-schelling/timonos/tree/7b56ccb6e760ece2e60f99ce5765bc527f5c11e5/src/system/common/networking https://github.com/timon-schelling/timonos/blob/main/src/user/apps/settings/wifi/app.nix
  options.networking = {
    enable = mkEnableOption "Enable networking settings";
    dns.enable = mkEnableOption "Enable dns settings" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # DNS resolver
    services.resolved = mkIf cfg.dns.enable {
      enable = true;
      dnsovertls = "true";
      dnssec = "false";
      domains = [ "~." ];
      fallbackDns = config.networking.nameservers;
    };

    # NOTE: dont wait for network to be online while booting
    systemd.network = {
      enable = true;
      wait-online.enable = false;
    };

    networking = {
      domain = "weriomat.com";
      # NOTE: DoT -> `https://shivering-isles.com/2021/01/configure-dot-on-systemd-resolved`
      nameservers = mkIf cfg.dns.enable [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "9.9.9.9#dns.quad9.net"
      ];
      dhcpcd.extraConfig = mkIf cfg.dns.enable "nohook resolv.conf";
      resolvconf.enable = mkIf cfg.dns.enable (mkForce false);

      networkmanager = {
        enable = true;
        dns = if cfg.dns.enable then mkForce "none" else "default"; # NOTE: tell nm not to touch /etc/resolv.conf
        wifi.powersave = true;
      };

      hostName = "${globals.hostname}";
      useNetworkd = true;

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
      nftables.enable = true;
    };
  };
}
