# TODO: https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/hyprland/config.nix
# TODO: https://wiki.hyprland.org/Configuring/Binds/#switches
{
  config,
  pkgs,
  lib,
  globals,
  ...
}:
let
  inherit (lib)
    getExe'
    mkIf
    ;
  cfg = config.my_hyprland;
in
{
  config = mkIf cfg.enable {
    catppuccin.hyprland = {
      enable = true;
      flavor = "mocha";
    };

    wayland.windowManager.hyprland = {
      # Create a easy way to resize windows; from https://www.reddit.com/r/hyprland/comments/14jehzj/creating_keybindings_to_resize_a_window/
      # extraConfig = /* hyprlang */ ''
      #   # will switch to a submap called resize
      #   bind = ALT, R, submap, resize

      #   # will start a submap called "resize"
      #   submap = resize

      #   # sets repeatable binds for resizing the active window
      #   binde = , right, resizeactive, 10 0
      #   binde = , left, resizeactive, -10 0
      #   binde = , up, resizeactive, 0 -10
      #   binde = , down, resizeactive, 0 10
      #   binde = , l, resizeactive, 50 0
      #   binde = , h, resizeactive, -50 0
      #   binde = , k, resizeactive, 0 -40
      #   binde = , j, resizeactive, 0 40

      #   # use reset to go back to the global submap
      #   bind = , escape, submap, reset

      #   # will reset the submap, which will return to the global submap
      #   submap = reset
      # '';

      extraConfig = /* lua */ ''
        mod = "SUPER"

        -- FIXME: build this via nix
        require("lua/animations")
        require("lua/decoration")
        require("lua/binds")
        require("lua/env")
        require("lua/monitors")
        require("lua/settings")
        require("lua/windowrules")


        hl.on("hyprland.start", function()
        	hl.exec_cmd("${getExe' globals.systemd "systemctl"} --user import-environment &")
        	hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null &")

          -- # TODO: maybe --all
        	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &")

        	hl.exec_cmd("${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} setcursor Nordzy-cursors 22 &")
        	hl.exec_cmd("${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch workspace 1&")
        	hl.exec_cmd("${getExe' globals.systemd "systemctl"} --user restart kanshi.service waybar.service")
        	hl.exec_cmd("${getExe' pkgs.solaar "solaar"} --window=hide")
        end)
      '';

      # TODO: fix this -> gnone auth agent
      # "gnome-keyring-daemon --start &"
      # "xwaylandvideobridge" # TODO: here

      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#minimize-steam-instead-of-killing
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey
    };

    xdg.configFile =
      let
        files = [
          ./animations.lua
          ./binds.lua
          ./decoration.lua
          ./env.lua
          ./monitors.lua
          ./settings.lua
          ./windowrules.lua
        ];
      in
      builtins.listToAttrs (
        map (e: {
          name = "hypr/lua/${baseNameOf e}";
          value = {
            source = e;
          };
        }) files
      );
  };
}
