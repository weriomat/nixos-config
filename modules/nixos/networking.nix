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
    mkOption
    types
    getExe'
    getExe
    optionalString
    ;
  cfg = config.networking;
  wlan-name = cfg.networkd.wlan.name;
  lan-name = cfg.networkd.lan.name;
in
# dock-name = "dock0";
{
  # TODO: this namespace already exist, move all options to seperate namespace?
  # TODO: switch to networkd? https://github.com/timon-schelling/timonos/tree/7b56ccb6e760ece2e60f99ce5765bc527f5c11e5/src/system/common/networking https://github.com/timon-schelling/timonos/blob/main/src/user/apps/settings/wifi/app.nix
  options.networking = {
    enable = mkEnableOption "networking settings";
    dns.enable = mkEnableOption "dns settings" // {
      default = true;
    };
    networkd = {
      enable = mkEnableOption "systemd-network instead of networkmanager" // {
        # TODO: here
        # default = true;
      };
      mac-random = mkEnableOption "MAC address randomization";
      bond = mkEnableOption "creating a bond out of Lan Wlan dock";

      wlan.name = mkOption {
        type = types.str;
        default = "wlan0";
        description = ''
          Name for the wireless interface
        '';
      };
      wlan.mac = mkOption {
        type = types.str;
        description = ''
          MAC addr for the wireless interface
        '';
      };
      lan.name = mkOption {
        type = types.str;
        default = "eth0";
        description = ''
          Name for the wired interface
        '';
      };
      lan.mac = mkOption {
        type = types.str;
        description = ''
          MAC addr for the wired interface
        '';
      };
    };
    iwd = {
      enable = mkEnableOption "iwd as wifi backend"; # this should be enabled at a per host basis
      debug = mkEnableOption "debugging option";
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
    systemd = {
      # From https://insanity.industries/post/racefree-iwd/
      services.iwd =
        let
          name = [ "sys-subsystem-net-devices-${wlan-name}.device" ];
        in
        mkIf cfg.iwd.enable {
          after = name;
          requires = name;
          environment.IWD_TLS_DEBUG = mkIf cfg.iwd.debug "TRUE";
        };

      # TODO: https://insanity.industries/post/random-mac-addresses-for-privacy/
      network = {
        enable = true;
        wait-online.enable = false;
        # TODO: remove
        links = {
          "10-${wlan-name}" = {
            enable = true;
            matchConfig.PermanentMACAddress = cfg.networkd.wlan.mac;
            linkConfig = {
              Name = wlan-name;
              MACAddressPolicy = mkIf cfg.networkd.mac-random "random"; # problem with static ips
            };
          };
          "10-${lan-name}" = {
            matchConfig.PermanentMACAddress = cfg.networkd.lan.mac;
            linkConfig = {
              Name = lan-name;
              MACAddressPolicy = mkIf cfg.networkd.mac-random "random";
            };
          };
        };
      };
      # // mkIf cfg.networkd.enable {
      #     "40-${lan-name}" = {
      #       enable = true;
      #       matchConfig.Name = lan-name;
      #       networkConfig =
      #         if cfg.networkd.bond then
      #           {
      #             DHCP = true; # systemd-networkd will use its own dhcp client
      #             IPv6PrivacyExtensions = true;
      #             MulticastDNS = true;
      #             IPv6AcceptRA = true;
      #           }
      #         else
      #           {
      #             Bond = "bond0";
      #             PrimarySlave = true; # TODO: check if dock should be primary as well
      #           };

      #       dhcpV4Config = mkIf (!cfg.networkd.bond) {
      #         # [DHCP] DUIDType=link-layer-time:2021-07-01 08:31:00
      #         Anonymize = mkIf cfg.networkd.mac-random true; # should only be used if link MACAddressPolicy = random
      #         UseDNS = false; # this might screw with captas
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #       };
      #       dhcpV6Config = mkIf (!cfg.networkd.bond) {
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #         # RapidCommit=true
      #       };
      #     };
      #     "40-${wlan-name}" = {
      #       enable = true;
      #       matchConfig.Name = wlan-name;
      #       networkConfig =
      #         if cfg.networkd.bond then
      #           {
      #             # systemd-networkd will use its own dhcp client
      #             DHCP = true;
      #             IPv6PrivacyExtensions = true;
      #             MulticastDNS = true;
      #             IPv6AcceptRA = true;
      #             IgnoreCarrierLoss = "2s";
      #           }
      #         else
      #           {
      #             Bond = "bond0";
      #             # TODO: check what an active slave is
      #           };
      #       dhcpV4Config = mkIf (!cfg.networkd.bond) {
      #         # [DHCP] DUIDType=link-layer-time:2021-07-01 08:31:00
      #         Anonymize = mkIf cfg.networkd.mac-random true; # should only be used if link MACAddressPolicy = random
      #         UseDNS = false; # this might screw with captas
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #       };
      #       dhcpV6Config = mkIf (!cfg.networkd.bond) {
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #         # RapidCommit=true
      #       };
      #     };
      # };
      # }// mkIf cfg.networkd.bond {
      #   links = {
      #     "10-${dock-name}" = {
      #       enable = true;
      #       matchConfig.MACAddress = "38:7c:76:02:58:90";
      #       linkConfig.Name = dock-name;
      #     };
      #   };
      #   netdevs."30-bond0" = {
      #     enable = true;
      #     netdevConfig = {
      #       Name = "bond0";
      #       Kind = "bond";
      #     };

      #     bondConfig = {
      #       Mode = "active-backup";
      #       PrimaryReselectPolicy = "always";
      #       MIIMonitorSec = "1s";
      #     };
      #   };
      #   # TODO: factor out common config
      #   networks = {
      #     "40-${dock-name}" = {
      #       enable = true;
      #       matchConfig.Name = dock-name;
      #       networkConfig =
      #         if cfg.networkd.bond then
      #           {
      #             Bond = "bond0";
      #           }
      #         else
      #           {
      #             DHCP = true; # systemd-networkd will use its own dhcp client
      #             IPv6PrivacyExtensions = true;
      #             MulticastDNS = true;
      #             IPv6AcceptRA = true;
      #           };

      #       dhcpV4Config = mkIf (!cfg.networkd.bond) {
      #         # Anonymize = true; # should only be used if link MACAddressPolicy = random
      #         # UseDNS = false; # this might screw with captas
      #         # SendHostname = false;
      #         # UseCaptivePortal = true; # should be displayed under networkctl
      #       };
      #       dhcpV6Config = mkIf (!cfg.networkd.bond) {
      #         # SendHostname = false;
      #         # UseCaptivePortal = true; # should be displayed under networkctl
      #         # RapidCommit=true
      #       };
      #     };

      #     "50-bond0" = mkIf cfg.networkd.bond {
      #       enable = true;
      #       matchConfig.Name = wlan-name;
      #       linkConfig.RequiredForOnline = "routable";
      #       networkConfig = {
      #         DHCP = true; # systemd-networkd will use its own dhcp client
      #         IPv6PrivacyExtensions = true;
      #         MulticastDNS = true;
      #         IPv6AcceptRA = true;
      #         IgnoreCarrierLoss = "2s";
      #       };
      #       dhcpV4Config = {
      #         # [DHCP] DUIDType=link-layer-time:2021-07-01 08:31:00
      #         Anonymize = mkIf cfg.networkd.mac-random true; # should only be used if link MACAddressPolicy = random
      #         UseDNS = false; # this might screw with captas
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #       };

      #       dhcpV6Config = {
      #         SendHostname = false;
      #         UseCaptivePortal = true; # should be displayed under networkctl
      #         # RapidCommit=true
      #       };
      # };
      # };
      # };
    };

    # from https://insanity.industries/post/simple-networking/
    services.udev.extraRules = builtins.concatStringsSep "\n" [
      (optionalString cfg.iwd.enable ''
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="1", RUN+="${getExe' pkgs.systemd "systemctl"} --no-block start iwd.service"
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="0", RUN+="${getExe' pkgs.systemd "systemctl"} --no-block stop iwd.service"
      '')
      (optionalString cfg.networkd.mac-random ''
        SUBSYSTEM=="rfkill", ATTR{name}=="phy0", ACTION=="change", ATTR{soft}=="1", RUN+="${getExe pkgs.macchanger} -ab ${wlan-name}"
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

      # networkmanager = mkIf (!cfg.networkd.enable)
      networkmanager =
        if cfg.networkd.enable then
          {
            enable = false;
          }
        else
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

      # TODO: lid switch and WLAN from https://wiki.archlinux.org/title/NetworkManager 8.6
      # TODO: ntp from https://wiki.archlinux.org/title/NetworkManager 5.2.9
      # TODO: captive portal from https://wiki.archlinux.org/title/NetworkManager 4.5
      # TODO: networkd dispatch script, if lan is present disable wlan, siehe 5.2.5 https://wiki.archlinux.org/title/NetworkManager
      # TODO: wireguard with https://unix.stackexchange.com/questions/554107/set-routing-metrics-for-static-ips-with-systemd-networkd -> RouteMetric
      wireless.iwd = mkIf cfg.iwd.enable {
        enable = true;
        settings = {
          General = {
            # EnableNetworkConfiguration = !cfg.networkd.enable; # let networkd handle dhcp/ ip assignment, if need for static mac for a specific network is needed, this is a good option since https://insanity.industries/post/simple-networking/
            AddressRandomization = mkIf cfg.networkd.mac-random "once";
          };
          DriverQuirks.UseDefaultInterface = true;

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
