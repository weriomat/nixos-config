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
    mkMerge
    ;
  cfg = config.networking;
  wlan-name = cfg.networkd.wlan.name;
  lan-name = cfg.networkd.lan.name;
in
{
  # TODO: this namespace already exist, move all options to separate namespace?
  # TODO: switch to networkd? https://github.com/timon-schelling/timonos/tree/7b56ccb6e760ece2e60f99ce5765bc527f5c11e5/src/system/common/networking https://github.com/timon-schelling/timonos/blob/main/src/user/apps/settings/wifi/app.nix
  options.networking = {
    enable = mkEnableOption "networking settings";
    dns.enable = mkEnableOption "dns settings" // {
      default = true;
    };
    networkd = {
      enable = mkEnableOption "systemd-network instead of networkmanager";

      mac-random = mkEnableOption "MAC address randomization";
      bond = mkEnableOption "creating a bond out of Lan Wlan dock";

      wlan = {
        enable = mkEnableOption "wlan via networkd" // {
          default = true;
        };

        name = mkOption {
          type = types.str;
          default = "wlan0";
          description = ''
            Name for the wireless interface
          '';
        };
        mac = mkOption {
          type = types.str;
          description = ''
            MAC addr for the wireless interface
          '';
        };
      };

      lan = {
        name = mkOption {
          type = types.str;
          default = "eth0";
          description = ''
            Name for the wired interface
          '';
        };
        mac = mkOption {
          type = types.str;
          description = ''
            MAC addr for the wired interface
          '';
        };
      };
    };
    iwd = {
      enable = mkEnableOption "iwd as wifi backend"; # this should be enabled at a per host basis
      debug = mkEnableOption "debugging option";
    };
  };

  config = mkIf cfg.enable {
    # browser for captive portals
    programs.captive-browser = mkIf cfg.networkd.wlan.enable {
      enable = true;
      interface = wlan-name;
    };

    # NOTE: dont wait for network to be online while booting
    systemd = {
      # From https://insanity.industries/post/racefree-iwd/
      services.iwd =
        let
          name = [ "sys-subsystem-net-devices-${wlan-name}.device" ];
        in
        mkIf (cfg.iwd.enable && cfg.networkd.wlan.enable) {
          after = name;
          requires = name;
          environment.IWD_TLS_DEBUG = mkIf cfg.iwd.debug "TRUE";
        };

      network = mkMerge [
        {
          enable = true;
          wait-online.enable = false;
          links = {
            "10-${wlan-name}" = mkIf cfg.networkd.wlan.enable {
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
        }
        (mkIf cfg.networkd.enable {
          networks = {
            "40-${lan-name}" = {
              enable = true;
              matchConfig.Name = lan-name;
              networkConfig = {
                DHCP = true; # systemd-networkd will use its own dhcp client
                IPv6PrivacyExtensions = true;
                MulticastDNS = true;
                IPv6AcceptRA = true;
              };

              dhcpV4Config = {
                # [DHCP] DUIDType=link-layer-time:2021-07-01 08:31:00
                Anonymize = cfg.networkd.mac-random; # should only be used if link MACAddressPolicy = random
                UseDNS = false; # this might screw with captas
                SendHostname = false;
                # UseCaptivePortal = true; # should be displayed under networkctl
              };
              dhcpV6Config = {
                SendHostname = false;
                # UseCaptivePortal = true; # should be displayed under networkctl
                # RapidCommit=true
              };
            };
            "40-${wlan-name}" = mkIf cfg.networkd.wlan.enable {
              enable = true;
              matchConfig.Name = wlan-name;
              networkConfig = {
                # systemd-networkd will use its own dhcp client
                DHCP = true;
                IPv6PrivacyExtensions = true;
                MulticastDNS = true;
                IPv6AcceptRA = true;
                IgnoreCarrierLoss = "2s";
              };

              dhcpV4Config = {
                # [DHCP] DUIDType=link-layer-time:2021-07-01 08:31:00
                Anonymize = cfg.networkd.mac-random; # should only be used if link MACAddressPolicy = random
                UseDNS = false; # this might screw with captas
                SendHostname = false;
                RouteMetric = 2048; # prefer lan
                # UseCaptivePortal = true; # should be displayed under networkctl
              };
              dhcpV6Config = {
                SendHostname = false;
                RouteMetric = 2048; # prefer lan
                # UseCaptivePortal = true; # should be displayed under networkctl
                # RapidCommit=true
              };
            };
          };
        })
      ];
    };

    # TODO: Take a look at https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/mac-randomize.nix
    # # Enable MAC Randomize
    # systemd.services.macchanger = {
    #   enable = true;
    #   description = "Change MAC address";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.macchanger}/bin/macchanger -r wlp0s20f3";
    #     ExecStop = "${pkgs.macchanger}/bin/macchanger -p wlp0s20f3";
    #     RemainAfterExit = true;
    #   };
    # };

    # from https://insanity.industries/post/simple-networking/
    services = {
      udev.extraRules = builtins.concatStringsSep "\n" [
        # disable iwd when rfkill'ing wifi `rfkill list all`, `rfkill block wlan`, `rfkill unblock wlan` (hard block -> hardware) (TLP has `wifi <on|off|toggle>` utility)
        (optionalString (cfg.iwd.enable && cfg.networkd.wlan.enable) ''
          SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="1", RUN+="${getExe' config.systemd.package "systemctl"} --no-block restart iwd.service"
          SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="0", RUN+="${getExe' config.systemd.package "systemctl"} --no-block stop iwd.service"
        '')
        (optionalString (cfg.networkd.mac-random && cfg.networkd.wlan.enable) ''
          SUBSYSTEM=="rfkill", ATTR{name}=="phy0", ACTION=="change", ATTR{soft}=="1", RUN+="${getExe pkgs.macchanger} -ab ${wlan-name}"
        '')
      ];
      # DNS resolver
      services.resolved = mkIf cfg.dns.enable {
        enable = true;
        dnsovertls = "true";
        dnssec = "false";
        domains = [ "~." ];
        fallbackDns = config.networking.nameservers;
      };

      chrony = {
        enable = true;
        enableNTS = true;
      };
    };

    environment.systemPackages = mkIf (cfg.iwd.enable && cfg.networkd.wlan.enable) [
      pkgs.iwgtk # applet is automatically included
      pkgs.impala # tui
    ];

    networking = {
      domain = "weriomat.com";
      # NOTE: DoT -> `https://shivering-isles.com/2021/01/configure-dot-on-systemd-resolved`
      nameservers = mkIf cfg.dns.enable [
        # see https://developers.cloudflare.com/1.1.1.1/ip-addresses/#1111
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "2606:4700:4700::1111#one.one.one.one"
        "2606:4700:4700::1001#one.one.one.one"

        # see https://www.quad9.net/service/service-addresses-and-features
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
      ];
      timeServers = [
        "0.de.pool.ntp.org" # https://www.ntppool.org/zone/de
        "1.de.pool.ntp.org"
        "2.de.pool.ntp.org"
        "3.de.pool.ntp.org"
        "times.tu-berlin.de" # https://www.tu.berlin/campusmanagement/angebot/zeitserver
        "time.cloudflare.com" # https://developers.cloudflare.com/time-services/ntp/usage/
        "ptbtime1.ptb.de" # https://www.ptb.de/cms/en/ptb/fachabteilungen/abt9/gruppe-95/ref-952/time-synchronization-of-computers-using-the-network-time-protocol-ntp.html
        "ptbtime2.ptb.de"
        "ptbtime3.ptb.de"
        "ptbtime4.ptb.de"
        "time.fu-berlin.de" # https://old.zedat.fu-berlin.de/Time-Service
        "zeit.fu-berlin.de"
        "0.nixos.pool.ntp.org" # nixos default
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"

        "ntp.ripe.net"
        "ntps1-0.cs.tu-berlin.de"
        "ntps1-1.cs.tu-berlin.de"
        "time.esa.int"
        "time1.esa.int"
        "ntppool1.time.nl"
        "ntppool2.time.nl"
        "europe.pool.ntp.org"
      ];
      dhcpcd.extraConfig = mkIf cfg.dns.enable "nohook resolv.conf";
      resolvconf.enable = mkIf cfg.dns.enable (mkForce false);

      networkmanager = {
        enable = !cfg.networkd.enable;
        # TODO: this does not work
        dns = if cfg.dns.enable then mkForce "none" else "default"; # NOTE: tell nm not to touch /etc/resolv.conf
        wifi = {
          powersave = true;
          backend = mkIf cfg.iwd.enable "iwd";
        };
        settings.main.systemd-resolved = mkIf cfg.dns.enable (mkForce false);
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
            AddressRandomization = mkIf cfg.networkd.mac-random "once";
            EnableNetworkConfiguration = !cfg.networkd.enable; # let networkd handle dhcp/ ip assignment, if need for static mac for a specific network is needed, this is a good option since https://insanity.industries/post/simple-networking/
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
