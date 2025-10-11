{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.steam.enable;
in
{
  options.steam.enable = mkEnableOption "gaming hm setup";

  config = mkIf cfg.enable {
    catppuccin.mangohud.enable = true;

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    # home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

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
  };
}
