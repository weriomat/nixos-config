{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
in
{
  # TODO: zusammenfuerhen mit nixos config
  # TODO: remove unused
  # janked from cobalt
  # Zsh packages
  home.packages = mkMerge [
    [
      pkgs.bc # calc
      pkgs.cmatrix # -> hacker style

      # -- general utils
      pkgs.curl
      pkgs.delta
      pkgs.screen
      pkgs.dig
      pkgs.netcat-gnu
      pkgs.fd
      pkgs.fzf
      pkgs.lsof
      pkgs.imagemagick
      # ncdu
      pkgs.zip
      pkgs.neofetch
      pkgs.tree
      pkgs.tree-sitter
      pkgs.unzip
      pkgs.wget

      # -- system level utils
      pkgs.man
      pkgs.killall
      pkgs.file
      pkgs.moreutils
      pkgs.coreutils

      # -- bash scripting
      pkgs.shfmt
      pkgs.shellcheck

      # -- network
      # networking tools
      pkgs.iperf3
      pkgs.dnsutils # `dig` + `nslookup`
      pkgs.ldns # replacement of `dig`, it provide the command `drill`
      pkgs.aria2 # A lightweight multi-protocol & multi-source command-line download utility
      pkgs.socat # replacement of openbsd-netcat
      pkgs.nmap # A utility for network discovery and security auditing
      pkgs.ipcalc # it is a calculator for the IPv4/v6 addresses
      pkgs.nload
      pkgs.minio-client
    ]
    (mkIf pkgs.stdenv.isLinux [
      # -- system level utils
      pkgs.mlocate
      pkgs.parted
      # -- system information
      pkgs.usbutils
      pkgs.linuxPackages.cpupower
      pkgs.pciutils # lspci, setpci
      # -- network
      # networking tools
      pkgs.nethogs
      pkgs.traceroute
    ])
  ];
}
