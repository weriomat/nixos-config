{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
in
with pkgs;
{
  # TODO: zusammenfuerhen mit nixos config
  # janked from cobalt
  # Zsh packages
  home.packages = mkMerge [
    [
      bc # calc
      cmatrix # -> hacker style

      # -- general utils
      curl
      delta
      screen
      dig
      netcat-gnu
      fd
      fzf
      lsof
      imagemagick
      # ncdu
      zip
      neofetch
      tree
      tealdeer
      tree-sitter
      unzip
      wget

      # -- system level utils
      man
      killall
      file
      moreutils
      coreutils

      # -- bash scripting
      shfmt
      shellcheck

      # -- network
      # networking tools
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses
      nload
      minio-client
    ]
    (mkIf pkgs.stdenv.isLinux [
      # -- system level utils
      mlocate
      parted
      # -- system information
      usbutils
      linuxPackages.cpupower
      pciutils # lspci, setpci
      # -- network
      # networking tools
      nethogs
      traceroute
    ])
  ];
}
