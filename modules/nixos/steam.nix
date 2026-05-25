{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.steam;
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options.steam.enable = mkEnableOption "Gaming thingies";

  # TODO: https://github.com/JohnRTitor/nix-conf/blob/hyprland/modules/system/services/ananicy-cpp.nix + https://github.com/chaotic-cx/nyx/blob/035a14f12abe016db315413480fb913196c4ed14/pkgs/ananicy-cpp-rules/default.nix
  # This is going to be decided per host
  config = mkIf cfg.enable {
    services.pipewire.lowLatency.enable = true;
    programs = {
      # TODO: https://github.com/Alexays/Waybar/wiki/Module:-Gamemode
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
            inhibit_screensaver = 0;
          };
          custom = {
            start = "${getExe pkgs.libnotify} 'GameMode started'";
            end = "${getExe pkgs.libnotify} 'GameMode ended'";
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
