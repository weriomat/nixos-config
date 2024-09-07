{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.packages.enable = mkEnableOption "Enable packages";

  config = mkIf config.packages.enable {
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
      sops
      powertop
      pdfarranger
      ethtool
      lm_sensors
      fanctl

      pdfarranger

      # gnome disk
      gnome.gnome-disk-utility

      # unsave version of electron
      # etcher

      # learning git game
      oh-my-git
      prettyping
      unstable.libdrm
      ffmpeg

      # keyboard
      qmk

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
