{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.steam;
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options.steam.enable = mkEnableOption "Gaming thingies";

  # This is going to be decided per host
  config = mkIf cfg.enable {
    services.pipewire.lowLatency.enable = true;
    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
        };
      };
      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;
        platformOptimizations.enable = true; # from nix-gaming
      };
    };
    environment.systemPackages = [
      # TODO: here
      pkgs.gamemode
      pkgs.gamescope
      pkgs.winetricks

      pkgs.protonup-ng # instead of ge
    ];
    # ++ [
    #   inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.proton-ge
    #   inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-ge
    # ];
  };

  # home.packages = with pkgs; [
  #   lutris
  #   steam
  #   steam-run
  #   gamemode
  #   dxvk
  #   # parsec-bin

  #   gamescope

  #   # heroic
  #   mangohud

  #   steamPackages.steam-runtime
  #   r2modman

  #   heroic

  #   er-patcher
  # ];
}
