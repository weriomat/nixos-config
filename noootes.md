# crates
influxdb
slab - 

https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation
https://medium.com/@paolorechia/building-a-database-from-scratch-in-rust-part-1-6dfef2223673
https://elis.nu/blog/2021/02/detailed-setup-of-screen-sharing-in-sway/
https://elis.nu/blog/2021/06/setting-up-push-to-talk-in-mumble-on-sway/
https://gohugo.io/
https://www.unixtutorial.org/zfs-basics-enable-or-disable-compression/
https://github.com/LongerHV/nixos-configuration/blob/master/nixos/nasgul/selfhosted/monitoring.nix
https://wiki.archlinux.org/title/Laptop
https://nixos.wiki/wiki/Power_Management

# DNS
https://github.com/MayNiklas/nixos-adblock-unbound
https://wiki.nixos.org/wiki/Encrypted_DNS

# hibernate
https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/9
https://askubuntu.com/a/33192
https://gist.github.com/auth/github/callback?return_to=https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221&browser_session_id=82d53da4f965d8dc884e9f3951664da99b74bea8a056e208da89797654b40898&code=dd77a89548a5c58679e0&state=af11c088b000a6eaa959440106f53c988e08c9d4247c4ca242e49da9050a5ba2

# luks header
https://www.cyberciti.biz/security/how-to-backup-and-restore-luks-header-on-linux/

# zfs
https://forum.level1techs.com/t/zfs-guide-for-starters-and-advanced-users-concepts-pool-config-tuning-troubleshooting/196035

# wallpapers
https://www.artstation.com/aenamiart

# config to take a look at
https://github.com/Misterio77/nix-config


```nix
# Do not print sometimes helpful, but not always, info during boot,
# so it is harder to debug system when something goes wrong.
boot.kernelParams = [ "quiet" ];

services.dbus.implementation = "broker";

systemd.coredump.extraConfig = ''
  Storage=none
  ProcessSizeMax=0
'';


config, lib, ... }: {
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  networking.nftables.enable = true;

  # This gives me PTSD, I suggest you all keep at least two good IPs here just in case.
  services.timesyncd.servers = [
    "time.cloudflare.com"
    "ntp.time.in.ua"
    "216.239.35.4" # time2.google.com
    "216.239.35.12" # time4.google.com
  ];

  services.resolved.extraConfig = lib.generators.toKeyValue {} {
    DNSSEC = false; # Maybe some time in the future DNSSEC will be usable.
    DNSOverTLS = true;
    DNS = lib.concatStringsSep " " [
      "9.9.9.9#dns9.quad9.net"
      "1.1.1.1#cloudflare-dns.com"
      "8.8.8.8#dns.google"

      "149.112.112.112#dns.quad9.net"
      "1.0.0.1#cloudflare-dns.com"
      "8.8.4.4#dns.google"

      "2620:fe::fe#dns.quad9.net"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2001:4860:4860::8888#dns.google"

      "2620:fe::9#dns9.quad9.net"
      "2606:4700:4700::1001#cloudflare-dns.com"
      "2001:4860:4860::8844#dns.google"
    ];
  };

  systemd.network.networks = let 
    dhcpRAConf = metric: {
      UseDNS = false;
      RouteMetric = metric;
    };
    defNetworkConf = match: metric: {
      name = match;
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
      };
      dhcpV4Config = dhcpRAConf metric;
      dhcpV6Config = dhcpRAConf metric;
      ipv6AcceptRAConfig = dhcpRAConf metric;
    };
  in {
    "90-dhcp-ether" = defNetworkConf "en*" 1024;
    "90-dhcp-wlan" = defNetworkConf "wl*" 2048;
  };

  systemd.network.wait-online.anyInterface = true;

  systemd.targets."network-online".wantedBy = lib.mkForce [];
}



{ config, inputs, pkgs, ... }: {
  nix.package = pkgs.nixVersions.nix_2_23;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
    warn-dirty = false;
    flake-registry = "";
    trusted-users = [ "root" "@wheel" ];
  };

  nix.registry = {
    n = {
      to = builtins.parseFlakeRef "github:nixos/nixpkgs/${inputs.nixpkgs.rev}";
      exact = false; 
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = /*bash*/''
      echo "system changes:"
      ${config.nix.package}/bin/nix store diff-closures /run/current-system "$systemConfig" 
    '';
  };
}



{ pkgs, lib, ... }: {
  # Configuration of the xdg user dirs to create,.
  # As you may see i've added PROJECTS dir,
  # and made so all dirs are in lowercase.
  environment.etc."xdg/user-dirs.defaults".text = ''
    DOCUMENTS=documents
    DOWNLOAD=downloads
    MUSIC=music
    PICTURES=pictures
    PROJECTS=projects
    TEMPLATES=templates
  '';

  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update &
  # '';

  environment.sessionVariables = rec {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";

    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";

    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";

    ANDROID_USER_HOME = "${XDG_DATA_HOME}/android";

    TEXMFHOME = "${XDG_STATE_HOME}/texmf";
    TEXMFVAR = "${XDG_CACHE_HOME}/texmf";
    TEXMFCONFIG = "${XDG_CONFIG_HOME}/texmf";

    CARGO_HOME = "${XDG_STATE_HOME}/cargo";
    CARGO_TARGET_DIR = "${XDG_STATE_HOME}/cargo";

    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";

    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_PREFIX = "${XDG_STATE_HOME}/npm";

    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";

    GOPATH = "${XDG_STATE_HOME}/go";

    BUNDLE_USER_CONFIG = "${XDG_CONFIG_HOME}/bundle";
    BUNDLE_USER_CACHE = "${XDG_CACHE_HOME}/bundle";
    BUNDLE_USER_PLUGIN = "${XDG_DATA_HOME}/bundle";
  };
}

services.fail2ban.enable = true;

#exec 'systemctl import-environment --user PATH DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP; systemctl --user start sway.target'



{
  zramSwap.enable = true;

  # This is the size of a block device to be created, in a percentage of ram,
  # it doesnt reflect actual memory that is being used in any way.
  # Compression ratio expected to be at least 3x the size of a ram,
  # so having values above 100 is ok.
  zramSwap.memoryPercent = 200;

  boot.kernel.sysctl = {
    # Swapping with zram is much much faster than paging so we prioritize it.
    "vm.swappiness" = 100;
    # With zstd, the decompression is so slow
    # that that there's essentially zero throughput gain from readahead.
    # Prevents uncompressing any more than you absolutely have to,
    # with a minimal reduction to sequential throughput
    "vm.page-cluster" = 0;
  };
}
```
