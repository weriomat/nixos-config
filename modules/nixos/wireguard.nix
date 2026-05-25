{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) genAttrs;
  inherit (config.sops) secrets;
  conf = {
    format = "yaml";
    owner = "systemd-network";
  };
in
{
  sops.secrets = genAttrs [ "wg_preshared" "wg_private" ] (_: conf);

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # See: https://linuskarlsson.se/blog/wireguard-split-tunnel-with-systemd-networkd/ https://wiki.archlinux.org/title/WireGuard and https://kalnytskyi.com/posts/setup-wireguard-client-systemd-networkd/
  systemd.network = {
    enable = true;

    # TODO: ipv4 and v6 with route metrics
    netdevs = {
      "10-wg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = secrets.wg_private.path;
          ListenPort = 9918;
        };
        wireguardPeers = [
          {
            PublicKey = "ift6B0GxOIYL8n5l4C2GInhY/iXjrMqFMUM1YxMPcX0=";
            AllowedIPs = [
              "10.100.0.0/24"
              "fc00:0:0:100::0/56"
            ];
            PresharedKeyFile = secrets.wg_preshared.path;
            Endpoint = "49.13.52.45:51820"; # NOTE: explicit cuz of domain below -> no resolving
          }
        ];
      };
      "10-wg6" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg6";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = secrets.wg_private.path;
          ListenPort = 9919;
        };
        wireguardPeers = [
          {
            PublicKey = "ift6B0GxOIYL8n5l4C2GInhY/iXjrMqFMUM1YxMPcX0=";
            AllowedIPs = [
              "10.100.0.0/24"
              "fc00:0:0:100::0/56"
            ];
            PresharedKeyFile = secrets.wg_preshared.path;
            Endpoint = "2a01:4f8:c012:aced::1:51820"; # NOTE: explicit cuz of domain below -> no resolving
          }
        ];
      };
    };
    networks = {
      # Route/ Gateway only needed if we want to go outside of network, but this should only be there to access other services
      "40-wg" = {
        matchConfig.Name = "wg";
        linkConfig.ActivationPolicy = "manual";

        address = [
          "10.100.0.4/24"
          "fc00:0:0:100::4/56"
        ];
        DHCP = "no";

        dns = [
          "10.100.0.1#dns.wg.weriomat.com"
          "fc00:0:0:100::1#dns.wg.weriomat.com"
        ];
        domains = [ "weriomat.com" ];
        # TODO: set up clients (systemd networkd) only support NTP not NTS https://github.com/systemd/systemd/issues/9481
        ntp = [ "ntp.wg.weriomat.com" ]; # if NTS is enabled
      };

      "40-wg6" = {
        matchConfig.Name = "wg6";
        address = [
          "10.100.0.4/24"
          "fc00:0:0:100::4/56"
        ];
        DHCP = "no";

        dns = [
          "10.100.0.1#dns.wg.weriomat.com"
          "fc00:0:0:100::1#dns.wg.weriomat.com"
        ];
        domains = [ "weriomat.com" ];
        # TODO: set up clients (systemd networkd) only support NTP not NTS https://github.com/systemd/systemd/issues/9481
        ntp = [ "ntp.wg.weriomat.com" ]; # if NTS is enabled
      };
    };
  };
}
