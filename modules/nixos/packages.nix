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
    # TODO: take a loojk at https://github.com/mfontanini/presenterm
    # trash-cli
    # procs
    # https://gitlab.freedesktop.org/mstoeckl/waypipe
    environment.systemPackages = with pkgs; [
      sqlite # if nix db fails
      iotop
      gnome-terminal # replacement terminal if kitty fails
      unixtools.netstat
      wireguard-tools
      # CLI
      devenv # nix shell -> TODO: contribute
      caligula
      unstable.siomon
      duf # df alternative
      ncdu # du alternative
      dust # du alternative
      dogdns # dig alternative
      vim
      powertop # system power thingie

      # TUI
      glow # view markdown on cli
      # sysz # systemctl thingy
      # clerk # mpd client

      ethtool
      lm_sensors
      fanctl

      # fetchers
      ipfetch
      cpufetch
      ramfetch
      zfxtop
      kmon

      python3 # python is handy sometimes
    ];
  };
}
