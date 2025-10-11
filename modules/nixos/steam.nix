{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
  options.steam.enable = mkEnableOption "Gaming thingies";

  # This is going to be decided per host
  config = mkIf config.steam.enable {
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
      };
    };
    environment.systemPackages = [
      # TODO: here
      pkgs.gamemode
      pkgs.gamescope
      pkgs.winetricks

      pkgs.protonup # instead of ge
    ];
    # ++ [
    #   inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    #   inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    # ];
  };

  # home.packages = with pkgs; [
  #   lutris
  #   steam
  #   steam-run
  #   protonup-ng
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
