{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.packages.enable = mkEnableOption "Enable packages";

  config = mkIf config.packages.enable {
    # TODO: remove ++ unify with hm packages
    # TODO: take a look at zenmonitor
    environment.systemPackages = with pkgs; [
      nurl # simple nix prefetch
      duf # df alternative
      ncdu # du alternative
      dogdns # dig alternative
      dust

      glow # view markdown on cli

      sysz # systemctl thingie
      clerk # mpd client

      buku # private db manager

      emojify # emoji on shell

      mermaid-cli
      powertop
      pdfarranger
      ethtool
      lm_sensors
      fanctl

      pdfarranger

      # gnome disk
      gnome.gnome-disk-utility

      # learning git game
      oh-my-git
      prettyping
      unstable.libdrm
      ffmpeg

      nixos-rebuild
      vim
      wget

      # nix
      nixfmt-classic
      nixpkgs-fmt
      nixpkgs-lint
      statix

      # build tools
      autoconf
      gnumake

      # -- Dev tools --
      ansible
      nodejs
      go
      openjdk
      (pkgs.python3.withPackages (p:
        with p; [
          pandas
          ffmpeg-python
          isort
          pygments
          requests
          keyring
          numpy
          dnslib
          pytest
          scipy
          git-filter-repo
          yt-dlp
          matplotlib
        ]))
      python3

      gcc
      llvm
      clang_15
      clang-tools_15
      extra-cmake-modules
      llvmPackages_latest.lldb
      plasma5Packages.extra-cmake-modules
      mold
      valgrind
      unstable.llvm
      unstable.clang_15
      unstable.clang-tools_15
      unstable.cmake
      unstable.extra-cmake-modules
      unstable.plasma5Packages.extra-cmake-modules
      unstable.mold
      unstable.valgrind
    ];
  };
}
