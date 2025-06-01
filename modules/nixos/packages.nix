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
      devenv # nix shell

      duf # df alternative
      ncdu # du alternative
      dust # du alternative
      dogdns # dig alternative

      glow # view markdown on cli

      sysz # systemctl thingie
      clerk # mpd client
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

      vim
      wget

      # TODO: remove dev deps since we want to use devshells for this

      python3

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
