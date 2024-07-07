{
  pkgs,
  lib,
  config,
  ...
}: {
  options.packages = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable packages";
    };
  };
  config = lib.mkIf config.packages.enable {
    environment.systemPackages = with pkgs; [
      mermaid-cli
      # TODO: check
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
      wireshark
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

      neofetch

      (haskellPackages.ghcWithPackages (pkgs:
        with pkgs; [
          stack
          cabal-install
          MonadRandom
          multiset-comb
          haskell-language-server
        ]))

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
