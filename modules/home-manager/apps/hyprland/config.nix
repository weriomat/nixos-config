# TODO: clean up this file
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
  inherit (lib) getExe';
in
{
  catppuccin.hyprland = {
    enable = true;
    flavor = "mocha";
  };

  wayland.windowManager.hyprland = {
    # Create a easy way to resize windows; from https://www.reddit.com/r/hyprland/comments/14jehzj/creating_keybindings_to_resize_a_window/
    extraConfig = /* hyprlang */ ''
      # will switch to a submap called resize
      bind = ALT, R, submap, resize

      # will start a submap called "resize"
      submap = resize

      # sets repeatable binds for resizing the active window
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      binde = , l, resizeactive, 50 0
      binde = , h, resizeactive, -50 0
      binde = , k, resizeactive, 0 -40
      binde = , j, resizeactive, 0 40

      # use reset to go back to the global submap
      bind = , escape, submap, reset

      # will reset the submap, which will return to the global submap
      submap = reset
    '';

    settings = {
      # TODO: package name
      # TODO: provision workspaces better -> use enable options
      workspace = [
        "1, monitor: HDMI-A-1, default:true, on-created-empty:kitty"
        "2, monitor: HDMI-A-1, on-created-empty:vikunja-desktop"
        "3, monitor: HDMI-A-1, on-created-empty:thunderbird"
        "4, monitor: HDMI-A-1, on-created-empty:${config.discord.executable}"
        "5, monitor: HDMI-A-1, on-created-empty:keepassxc"
        "6, monitor: DP-1, default:true, on-created-empty:firefox"
        "7, monitor: DP-1"
        "8, monitor: DP-1"
        "9, monitor: DP-1"
        "10, monitor: DP-1"
        "11, monitor: DP-3, default:true, on-created-empty:cider"
      ];

      env = [
        # Toolkit backend
        "GTK_USE_PORTAL, 1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"

        # XDG
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # QT
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        # DISABLE_QT5_COMPAT = "0";

        # Theming
        "XCURSOR_SIZE,24"
        "GTK_THEME,Catppuccin-Mocha-Compact-Lavender-Dark"
        # "XCURSOR_THEME" # TODO:
        # "HYPRCURSOR_THEME,${config.stylix.cursor.name}"

        # Applications
        "NIXOS_OZONE_WL,1"
        # __GL_GSYNC_ALLOWED = "0";
        # __GL_VRR_ALLOWED = "0";
        # _JAVA_AWT_WM_NONEREPARENTING = "1";
        "ANKI_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        # "_JAVA_AWT_WM_NONEREPARENTING,1"
        # "_JAVA_OPTIONS,-Dawt.useSystemAAFontSettings=on"
        # "JAVA_FONTS,/usr/share/fonts/TTF"

      ];
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#minimize-steam-instead-of-killing
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey

      exec-once = [
        "${getExe' globals.systemd "systemctl"} --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        # TODO: maybe --all
        # TODO: fix this -> gnone auth agent
        # "gnome-keyring-daemon --start &"
        # "xwaylandvideobridge" # TODO: here
        "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} setcursor Nordzy-cursors 22 &"
        "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch workspace 1&"
        "${getExe' globals.systemd "systemctl"} --user restart kanshi.service waybar.service"
        "${getExe' pkgs.solaar "solaar"} --window=hide" # Enable solaar applet, for more see keyboard config
      ];
    };
  };
}
