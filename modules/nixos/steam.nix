{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.steam.enable = mkEnableOption "Enable Gaming thingies";

  # This is going to be decided per host
  config = mkIf config.steam.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall =
          true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall =
          true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      lunar-client
      # TODO: here
      gamemode
      gamescope
      winetricks

      protonup # instead of ge
      # mangohud
    ];
    # ++ [
    #   inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    #   inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    # ];
    # TODO: here
    # gamemode.enable = true;
  };

  # https://github.com/danth/stylix/blob/master/modules/mangohud/hm.nix
  # home.sessionVariables = {
  #   STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  # };

  # programs.mangohud.enable = true;

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
