{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  wallpaper_path = "${pkgs.weriomat-wallpapers}";
in {
  options.wallpapers.enable = mkEnableOption "Enable Wallpaper configuration";

  # TODO: make all binaries static -> sollte die dann aus den runtime inputs nehmen koennen
  config =
    mkIf config.wallpapers.enable
    {
      home.packages = builtins.attrValues {
        wall-change =
          pkgs.writeShellApplication
          {
            name = "wall-change";
            runtimeInputs = with pkgs; [swaybg killall];
            text = ''
              ${pkgs.killall}/bin/killall swaybg || true
              ${pkgs.swaybg}/bin/swaybg -m fill -i "$1"
            '';
          };
      };

      wayland.windowManager.hyprland.settings = let
        dynwallpaper = pkgs.writeShellApplication {
          name = "dynwallpaper";
          runtimeInputs = with pkgs; [swaybg libnotify coreutils findutils];
          text = ''
            while true; do
              wallpaper_name="$(find ${wallpaper_path} | shuf -n 1)"
              w_name="$(echo "$wallpaper_name" | xargs basename)"
              if [[ -f $wallpaper_name ]]; then
                  wall-change "$wallpaper_name" &
                  notify-send -u normal "Changed Wallpaper to $w_name" &
              else
                  exit 1
              fi
              sleep 1800
            done
          '';
        };
      in {
        exec-once = ["${dynwallpaper}/bin/dynwallpaper &"];

        bind = let
          # TODO: fix this
          wallpaper-picker = pkgs.writeShellApplication {
            name = "wallpaper-picker";
            runtimeInputs = with pkgs; [
              libnotify
              swaybg
              wofi
              coreutils
              findutils
              killall
            ];
            text = ''
              wallpaper_path=${wallpaper_path}
              wallpaper_name="$(find "$wallpaper_path" -exec basename {} \; | wofi --show dmenu --sort-order=alphabetical)"
              if [[ -f $wallpaper_path/$wallpaper_name ]]; then
                  killall dynwallpaper || true
                  wall-change "$wallpaper_path"/"$wallpaper_name" &
                  notify-send -u normal "Changed Wallpaper to $wallpaper_name" &
              else
                  exit 1
              fi
            '';
          };
          wallpaper-random = pkgs.writeShellApplication {
            name = "wallpaper-random";
            runtimeInputs = with pkgs; [swaybg libnotify coreutils findutils];
            text = ''
              wallpaper_name="$(find ${wallpaper_path} | shuf -n 1)"
              w_name="$(echo "$wallpaper_name" | xargs basename)"
              if [[ -f $wallpaper_name ]]; then
                  killall dynwallpaper || true
                  wall-change "$wallpaper_name" &
                  notify-send -u normal "Changed Wallpaper to $w_name" &
              else
                  exit 1
              fi
            '';
          };
        in [
          "$mainMod, W, exec, ${wallpaper-picker}/bin/wallpaper-picker"
          "$mainMod SHIFT, W, exec, ${wallpaper-random}/bin/wallpaper-random"
        ];
      };
    };
}
