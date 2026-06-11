{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  wallpaper_path = "${pkgs.weriomat-wallpapers}";
in
{
  options.wallpapers.enable = mkEnableOption "Enable Wallpaper configuration";

  # TODO: make all binaries static -> sollte die dann aus den runtime inputs nehmen koennen
  config = mkIf config.wallpapers.enable {
    home.packages = builtins.attrValues {
      wall-change = pkgs.writeShellApplication {
        name = "wall-change";
        runtimeInputs = [
          pkgs.swaybg
          pkgs.killall
        ];
        text = ''
          ${pkgs.killall}/bin/killall swaybg || true
          ${pkgs.swaybg}/bin/swaybg -m fill -i "$1"
        '';
      };
    };

    wayland.windowManager.hyprland.extraConfig =

      let
        dynwallpaper = pkgs.writeShellApplication {
          name = "dynwallpaper";
          runtimeInputs = [
            pkgs.swaybg
            pkgs.libnotify
            pkgs.coreutils
            pkgs.findutils
          ];
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
        # TODO: fix this
        wallpaper-picker = pkgs.writeShellApplication {
          name = "wallpaper-picker";
          runtimeInputs = [
            pkgs.libnotify
            pkgs.swaybg
            pkgs.wofi
            pkgs.coreutils
            pkgs.findutils
            pkgs.killall
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
          runtimeInputs = [
            pkgs.swaybg
            pkgs.libnotify
            pkgs.coreutils
            pkgs.findutils
          ];
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
      in
      /* lua */ ''
        -- wallpapers
        hl.on("hyprland.start", function()
        	hl.exec_cmd("${dynwallpaper}/bin/dynwallpaper &")
        end)
        hl.bind(mod .. " + W", hl.dsp.exec_cmd("${getExe wallpaper-picker}"))
        hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("${getExe wallpaper-random}"))
      '';
  };
}
