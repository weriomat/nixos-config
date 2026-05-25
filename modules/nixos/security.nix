{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  # imports = [
  #   <nixpkgs/nixos/modules/profiles/hardened.nix>
  # ];
  options.hardening.enable = mkEnableOption "Enable hardening settings"; # // {
  # default = true;
  # };
  # TODO: integrate into Nixos-Server

  config = mkIf config.hardening.enable {
    # profiles.hardened.enable = true;
    # Inspired by https://github.com/Lassulus/superconfig/blob/32b0c6628fa4af136c635f62e1de9f83419712d0/2configs/hardening.nix
    security.chromiumSuidSandbox.enable = true;
  };

  # TODO: appamor: https://github.com/JohnRTitor/nix-conf/blob/7980277ccaff863ab3ca2808b98a814e9eea211d/modules/system/services/apparmor.nix
  # TODO: https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/linux-kernel.nix
  # TODO: https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop/src/branch/main/hardening/default.nix
  # TODO: deny filesystems https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop/src/branch/main/hardening/filesystem-deny-mount.nix
  # TODO: opensnitch https://git.grimmauld.de/Grimmauld/grimm-nixos-laptop/src/branch/main/hardening/opensnitch
  # TODO: https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/security-services.nix
  # TODO: servers
  # # security tweaks borrowed from @hlissner
  # {
  #   boot.kernel.sysctl = {
  #     # The Magic SysRq key is a key combo that allows users connected to the
  #     # system console of a Linux kernel to perform some low-level commands.
  #     # Disable it, since we don't need it, and is a potential security concern.
  #     "kernel.sysrq" = 0;

  #     ## TCP hardening
  #     # Prevent bogus ICMP errors from filling up logs.
  #     "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  #     # Reverse path filtering causes the kernel to do source validation of
  #     # packets received from all interfaces. This can mitigate IP spoofing.
  #     "net.ipv4.conf.default.rp_filter" = 1;
  #     "net.ipv4.conf.all.rp_filter" = 1;
  #     # Do not accept IP source route packets (we're not a router)
  #     "net.ipv4.conf.all.accept_source_route" = 0;
  #     "net.ipv6.conf.all.accept_source_route" = 0;
  #     # Don't send ICMP redirects (again, we're not a router)
  #     "net.ipv4.conf.all.send_redirects" = 0;
  #     "net.ipv4.conf.default.send_redirects" = 0;
  #     # Refuse ICMP redirects (MITM mitigations)
  #     "net.ipv4.conf.all.accept_redirects" = 0;
  #     "net.ipv4.conf.default.accept_redirects" = 0;
  #     "net.ipv4.conf.all.secure_redirects" = 0;
  #     "net.ipv4.conf.default.secure_redirects" = 0;
  #     "net.ipv6.conf.all.accept_redirects" = 0;
  #     "net.ipv6.conf.default.accept_redirects" = 0;
  #     # Protects against SYN flood attacks
  #     "net.ipv4.tcp_syncookies" = 1;
  #     # Incomplete protection again TIME-WAIT assassination
  #     "net.ipv4.tcp_rfc1337" = 1;

  #     ## TCP optimization
  #     # TCP Fast Open is a TCP extension that reduces network latency by packing
  #     # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
  #     # both incoming and outgoing connections:
  #     "net.ipv4.tcp_fastopen" = 3;
  #     # Bufferbloat mitigations + slight improvement in throughput & latency
  #     "net.ipv4.tcp_congestion_control" = "bbr";
  #     "net.core.default_qdisc" = "cake";
  #   };

  #   boot.kernelModules = [ "tcp_bbr" ];
  # }
}
