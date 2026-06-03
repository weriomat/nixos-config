{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.steam;
in
{
  options.steam.enable = mkEnableOption "gaming hm setup";
  # TODO: https://github.com/Sly-Harvey/NixOS/blob/master/modules/core/games.nix

  config = mkIf cfg.enable {
    catppuccin.mangohud.enable = true;

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    # from https://github.com/Sly-Harvey/NixOS/blob/master/modules/desktop/hyprland/default.nix
    wayland.windowManager.hyprland.extraConfig = /* lua */ ''
      hl.window_rule({
      	match = { tag = "games" },
      	content = "game",
      	sync_fullscreen = true,
      	fullscreen = true,
      	border_size = 0,
      	no_shadow = true,
      	no_blur = true,
      	no_anim = true,
      })
      hl.window_rule({
      	match = { content = "3" },
      	tag = "+games",
      })
      hl.window_rule({
      	match = { class = "^(steam_app.*|steam_app_\\d+)$" },
      	tag = "+games",
      })
      hl.window_rule({
      	match = { class = "^(gamescope)$" },
      	tag = "+games",
      })
      hl.window_rule({
      	match = { class = "(Waydroid)" },
      	tag = "+games",
      })
      hl.window_rule({
      	match = { class = "(osu!)" },
      	tag = "+games",
      })
      hl.window_rule({
      	match = { class = "^(com.libretro.RetroArch|[Rr]etro[Aa]rch)$" },
      	tag = "+games",
      })
    '';

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
