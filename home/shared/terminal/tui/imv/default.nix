{ lib, pkgs, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf pkgs.stdenv.isLinux {
    catppuccin.imv.enable = true;
    programs.imv = {
      enable = true;
      settings = {
        options.overlay_font = "Iosevka Nerd Font:10";
        # Rotate Clockwise by 90 degrees
        binds."<Ctrl+r>" = "rotate by 90";
      };
    };

    wayland.windowManager.hyprland.extraConfig = /* lua */ ''
      -- imv
      hl.window_rule({
      	match = { class = "^(.*imv.*)$" },

      	opacity = "1.0 override 1.0 override",
      })
    '';
  };
}
