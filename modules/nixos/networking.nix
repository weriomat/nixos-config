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
{
  # TODO: this namespace already exist, move all options to seperate namespace?
  # TODO: switch to networkd? https://github.com/timon-schelling/timonos/tree/7b56ccb6e760ece2e60f99ce5765bc527f5c11e5/src/system/common/networking https://github.com/timon-schelling/timonos/blob/main/src/user/apps/settings/wifi/app.nix
  options.networking = {
    enable = mkEnableOption "networking settings";
    dns.enable = mkEnableOption "dns settings" // {
      default = true;
    };
    networkd = {
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
    services.udev.extraRules = builtins.concatStringsSep "\n" [
      (optionalString cfg.iwd.enable ''
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="1", RUN+="${getExe' config.systemd.package "systemctl"} --no-block start iwd.service"
        SUBSYSTEM=="rfkill", ENV{RFKILL_NAME}=="phy0", ENV{RFKILL_TYPE}=="wlan", ACTION=="change", ENV{RFKILL_STATE}=="0", RUN+="${getExe' config.systemd.package "systemctl"} --no-block stop iwd.service"
      '')
      (optionalString cfg.networkd.mac-random ''
        SUBSYSTEM=="rfkill", ATTR{name}=="phy0", ACTION=="change", ATTR{soft}=="1", RUN+="${getExe pkgs.macchanger} -ab ${wlan-name}"
      '')
    ];

    environment.systemPackages = mkIf cfg.iwd.enable [
      pkgs.iwgtk # applet is automatically included
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

      networkmanager = {
        enable = true;
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
          General.AddressRandomization = mkIf cfg.networkd.mac-random "once";
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
