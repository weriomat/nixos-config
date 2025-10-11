{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.steam;
in
{
  options.steam.enable = mkEnableOption "gaming hm setup";

  config = mkIf cfg.enable {
    catppuccin.mangohud.enable = true;

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    wayland.windowManager.hyprland.settings = {
      # from https://github.com/Sly-Harvey/NixOS/blob/master/modules/desktop/hyprland/default.nix
      windowrule = [
        "content game, tag:games"
        "tag +games, content:game"
        "tag +games, class:^(steam_app.*|steam_app_\d+)$"
        "tag +games, class:^(gamescope)$"
        "tag +games, class:(Waydroid)"
        "tag +games, class:(osu!)"

        # Games
        "syncfullscreen,tag:games"
        "fullscreen,tag:games"
        "noborder 1,tag:games"
        "noshadow,tag:games"
        "noblur,tag:games"
        "noanim,tag:games"
      ];
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
