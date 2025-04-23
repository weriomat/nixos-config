{
  lib,
  config,
  globals,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkForce
    getExe'
    optionalString
    ;
  cfg = config.networking;
in
{
  # TODO: swithc to networkd? https://github.com/timon-schelling/timonos/tree/7b56ccb6e760ece2e60f99ce5765bc527f5c11e5/src/system/common/networking https://github.com/timon-schelling/timonos/blob/main/src/user/apps/settings/wifi/app.nix
  options.networking = {
    enable = mkEnableOption "networking settings";
    dns.enable = mkEnableOption "dns settings" // {
      default = true;
    };
    iwd.enable = mkEnableOption "iwd as wifi backend"; # this should be enabled at a per host basis
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

    # from https://insanity.industries/post/simple-networking/
    services.udev.extraRules = builtins.concatStringsSep "\n" [
      (optionalString cfg.iwd.enable ''
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="1", RUN+="${getExe' pkgs.systemd "systemctl"} --no-block start iwd.service"
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="0", RUN+="${getExe' pkgs.systemd "systemctl"} --no-block stop iwd.service"
      '')
    ];

    environment.systemPackages = mkIf cfg.iwd.enable [
      pkgs.iwgtk
      # TODO: iwgtk -i for applet
      pkgs.impala # tui
    ];

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

      networkmanager =
          {
            enable = true;
            # TODO: this does not work
            dns = if cfg.dns.enable then mkForce "none" else "default"; # NOTE: tell nm not to touch /etc/resolv.conf
            wifi = {
              powersave = true;
              backend = mkIf cfg.iwd.enable "iwd";
            };
            settings = {
              main.systemd-resolved = mkIf cfg.dns.enable (mkForce false);
              # device.wifi.iwd.autoconnect = mkIf cfg.iwd.enable "yes";
            };
          };

      wireless.iwd = mkIf cfg.iwd.enable {
        enable = true;
        settings = {
          General = {
            # EnableNetworkConfiguration = !cfg.networkd.enable; # let networkd handle dhcp/ ip assignment, if need for static mac for a specific network is needed, this is a good option since https://insanity.industries/post/simple-networking/
            UseDefaultInterface = true;
          };
          # General.
          Network = {
            EnableIPv6 = true;
            NameResolvingService = "systemd";
          };
        };
      };

      hostName = globals.hostname;
      useNetworkd = true;

      firewall = {
        enable = true;
        checkReversePath = "loose"; # cuz of vpn
      };
      nftables.enable = true;
    };
  };
}
