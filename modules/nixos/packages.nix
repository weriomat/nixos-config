{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.packages.enable = mkEnableOption "Enable packages";

  config = mkIf config.packages.enable {
    # TODO: remove ++ unify with hm packages
    # TODO: take a look at zenmonitor
    environment.systemPackages = with pkgs; [
      # vikunja-desktop # TODO: fix this
      devenv # nix shell

      duf # df alternative
      ncdu # du alternative
      dust # du alternative
      dogdns # dig alternative

      glow # view markdown on cli

      sysz # systemctl thingie
      clerk # mpd client

      emojify # emoji on shell

      powertop
      pdfarranger
      ethtool
      lm_sensors
      fanctl

      # fetchers
      ipfetch
      cpufetch
      ramfetch
      zfxtop
      kmon

      # learning git game
      oh-my-git
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

      # TODO: remove dev deps since we want to use devshells for this

      # build tools
      autoconf
      gnumake

      # -- Dev tools --
      ansible
      nodejs
      go
      openjdk
      (pkgs.python3.withPackages (
        p: with p; [
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
        ]
      ))
      python3

      gcc
      llvm
      clang_15
      clang-tools
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
      # TODO:  # -- Media Tools --
      # gimp
      # handbrake
      # mplayer
      # gthumb
      # jellyfin-media-player
      # jellyfin-mpv-shim
      # graphviz
    ];
  };
}
