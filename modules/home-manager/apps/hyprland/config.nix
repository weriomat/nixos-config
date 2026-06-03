{
  config,
  pkgs,
  lib,
  globals,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    removeSuffix
    mkIf
    ;

  files = [
    ./animations.lua
    ./binds.lua
    ./decoration.lua
    ./env.lua
    ./monitors.lua
    ./settings.lua
    ./windowrules.lua
  ];

  cfg = config.my_hyprland;
in
{
  config = mkIf cfg.enable {
    catppuccin.hyprland = {
      enable = true;
      flavor = "mocha";
    };

    wayland.windowManager.hyprland = {
      extraConfig =
        /* lua */ ''
          mod = "SUPER"

        ''
        + builtins.foldl' (
          acc: elem: acc + "require(\"lua/${removeSuffix ".lua" (baseNameOf elem)}\")\n"
        ) "" files
        + ''

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

          hl.permission({ binary = "${getExe pkgs.grim}", type = "screencopy", mode = "allow" })
          hl.permission({ binary = "${getExe config.programs.hyprlock.package}", type = "screencopy", mode = "allow" })
          hl.permission({ binary = "${config.wayland.windowManager.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", type = "screencopy", mode = "allow" })
        '';

      # TODO: fix this -> gnone auth agent
      # "gnome-keyring-daemon --start &"
      # "xwaylandvideobridge" # TODO: here

      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#minimize-steam-instead-of-killing
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey
    };

    xdg.configFile = builtins.listToAttrs (
      map (e: {
        name = "hypr/lua/${baseNameOf e}";
        value = {
          source = e;
        };
      }) files
    );
  };
}
