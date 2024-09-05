{
  config,
  pkgs,
  ...
}: {
  # TODO: here
  # # Fixes tray icons: https://github.com/nix-community/home-manager/issues/2064#issuecomment-887300055
  # systemd.user.targets.tray = {
  #   Unit = {
  #     Description = "Home Manager System Tray";
  #     Requires = ["graphical-session-pre.target"];
  #   };
  # };

  # TODO: here
  wayland.windowManager.hyprland = {
    settings = {
      # bindle = [
      #   # volume
      #   ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      #   ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      #   # backlight
      #   ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      #   ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      # ];

      # TODO: here
      bindl = [",switch:Lid Switch, exec, ${pkgs.laptop_lid_switch}"];

      # TODO: monitor = , highres, auto, 2
      monitor = [
        "DP-1, 2560x1440@144, 1920x0, 1"
        "DP-3, 1920x1080@240, 0x0, 1"
        "HDMI-A-1,  1920x1080@60, 4480x0, 1"
      ];
      workspace = [
        "1, monitor: DP-1, default:true, on-created-empty:kitty"
        "2, monitor: DP-1, on-created-empty:keepassxc"
        "3, monitor: DP-1, on-created-empty: vorta"
        "4, monitor: DP-1, on-created-empty: thunar"
        "5, monitor: DP-1"
        "6, monitor: DP-3, default:true, on-created-empty:firefox"
        "7, monitor: DP-3, on-created-empty: libreoffice"
        "8, monitor: DP-3"
        "9, monitor: DP-3"
        "10, monitor: DP-3"
        "11, monitor: HDMI-A-1, default:true, on-created-empty:cider"
        # "12, monitor: HDMI-A-1"
        # "13, monitor: HDMI-A-1"
        # "14, monitor: HDMI-A-1"
        # "15, monitor: HDMI-A-1"
      ];
      env = [
        # TODO: here
        # env = GDK_SCALE,2
        # env = XCURSOR_SIZE,32
        "XCURSOR_SIZE,24"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "GTK_THEME,Catppuccin-Mocha-Compact-Lavender-Dark"
        # "XCURSOR_THEME"
        # "XCURSOR_SIZE"
      ];
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#minimize-steam-instead-of-killing
      # TODO: https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey

      # TODO: steal from zayneyos/ cobalt
      # TODO: switch to nixpkgs paths
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        # TODO: maybe --all
        # TODO: fix this -> gnone auth agent
        # "gnome-keyring-daemon --start &"
        "systemctl --user restart pipewire polkit-gnome-authentication-agent-1 xdg-desktop-portal xdg-desktop-portal-wlr"
        # "xwaylandvideobridge" # TODO: here
        "nm-applet &"
        "wl-paste --primary --watch wl-copy --primary --clear &"
        "dynwallpaper &"
        # TODO: add kanshi
        "sway-audio-idle-inhibit &"
        "sleep 1 && swaylock"
        "sleep 1 && sleepidle &"
        "hyprctl setcursor Nordzy-cursors 22 &"
        "sleep 1; hyprctl dispatch workspace 1&"
        "waybar &"
        "mako &"
        "udiskie &"
        "discord &"
      ];

      "$mainMod" = "SUPER";
      # TODO: swithc to nix paths
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, K, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit, "
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, Q, exec, wlogout"

        # TODO: here
        # switchching focus with vim keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod, F, fullscreen, 1"
        "$mainMod SHIFT, F, fullscreen, 0"
        # kill waybar
        "$mainMod SHIFT, B, exec, pkill -SIGUSR1 .waybar-wrapped"

        # wallpaper picker
        "$mainMod, W, exec, wallpaper-picker"
        "$mainMod SHIFT, W, exec, wallpaper-random"

        # toggle for lofi music
        "$mainMod, L, exec, lofi"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 11"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # "# Example special workspace (scratchpad)""
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # TODO: move those to
        # media and volume control
        ",XF86AudioRaiseVolume, exec, pamixer -i 2"
        ",XF86AudioLowerVolume, exec, pamixer -d 2"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"

        # TODO: here
        # bind=,XF86AudioMicMute,exec, volume --toggle-mic
        # bind=ALT,XF86AudioPlay,exec,systemctl --user restart playerctld
        # bind=,XF86MonBrightnessUp,exec, brightness --inc
        # bind=,XF86MonBrightnessDown,exec, brightness --dec
        # ",XF86AudioMicMute" = "exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";

        # screenshot
        # "$mainMod SHIFT, 4, exec, grimblast --notify --cursor copysave area ~/Pictures/Screenshots/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
        # ",Print, exec, grimblast --notify --cursor  copy area"
        ",Print, exec, grimblast --notify --cursor copysave area ~/Pictures/Screenshots/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
      ];

      # TODO: here
      # bindi = {
      #   ",XF86MonBrightnessUp" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl +5%";
      #   ",XF86MonBrightnessDown" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl -5% ";
      #   ",XF86AudioRaiseVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -i 5";
      #   ",XF86AudioLowerVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -d 5";
      #   ",XF86AudioMute" = "exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute";
      #   ",XF86AudioMicMute" = "exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
      #   ",XF86AudioNext" = "exec,playerctl next";
      #   ",XF86AudioPrev" = "exec,playerctl previous";
      #   ",XF86AudioPlay" = "exec,playerctl play-pause";
      #   ",XF86AudioStop" = "exec,playerctl stop";
      # };

      bindm = [
        # "# Move/resize windows with mainMod + LMB/RMB and dragging"
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      # TODO: fix this -> https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
      windowrulev2 = [
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"

        # idleinhibit
        "idleinhibit fullscreen, class:^(firefox)$"
        "idleinhibit focus, class:^(firefox)$"
        "idleinhibit fullscreen, fullscreen:1"

        # Bitwarden extension
        "float, title:^(.*Bitwarden Password Manager.*)$"

        # throw sharing indicators away
        # "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        # "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(firefox)$"

        # "dimaround, class:^(gcr-prompter)$"
        # "dimaround, class:^(xdg-desktop-portal-gtk)$"
        # "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

        # fix xwayland apps
        "rounding 0, xwayland:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

        # don't render hyprbars on tiling windows
        # "plugin:hyprbars:nobar, floating:0"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {natural_scroll = "no";};

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };
      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        "col.active_border" = "rgb(${config.colorScheme.palette.base0E}) rgb(${config.colorScheme.palette.base0C}) 45deg";
        "col.inactive_border" = "0x00000000";
        # TODO: fix this
        # border_part_of_window = false;
        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 12;

        active_opacity = 0.9;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;

          size = 3;
          passes = 3;

          brightness = 1;
          contrast = "1.300000";
          ignore_opacity = true;
          noise = "0.011700";

          new_optimizations = true;

          xray = true;
        };
        # rounding = 10;

        # blur = {
        #   enabled = true;
        #   size = 3;
        #   passes = 1;
        # };

        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";
        # };

        drop_shadow = true;

        shadow_ignore_window = true;
        shadow_offset = "0 2";
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000055)";
      };

      animations = {
        enabled = true;
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];
        # Windows
        animation = [
          "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
          "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
          "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        # bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        # animation = [
        #   "windows, 1, 7, myBezier"
        #   "windowsOut, 1, 7, default, popin 80%"
        #   "border, 1, 10, default"
        #   "borderangle, 1, 8, default"
        #   "fade, 1, 7, default"
        #   "workspaces, 1, 6, default"
        # ];
      };

      xwayland = {force_zero_scaling = true;};

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        no_gaps_when_only = false;
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
        # pseudotile =
        #   true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        # preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        special_scale_factor = 1;
        no_gaps_when_only = false;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper =
          0; # Set to 0 to disable the anime mascot wallpapers
        disable_hyprland_logo = true;
      };
    };
    # extraConfig = if (config.globals.isLaptop) then ''
    #   # TODO: fix this -> not for desktop -> just need for laptop
    #   bind = ,XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set +5%
    #   bind = ,XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%-
    #   # Example per-device config
    #   # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    #   device:epic-mouse-v1 {
    #       sensitivity = -0.5
    #   }

    #   # Example windowrule v1
    #   # windowrule = float, ^(kitty)$
    #   # Example windowrule v2
    #   # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    #   # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # '' else ''
    #   # Example per-device config
    #   # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    #   device:epic-mouse-v1 {
    #       sensitivity = -0.5
    #   }

    #   # Example windowrule v1
    #   # windowrule = float, ^(kitty)$
    #   # Example windowrule v2
    #   # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    #   # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # '';
    # TODO: fix
    # extraConfig = ''
    #     # Example per-device config
    #     # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    #     device:epic-mouse-v1 {
    #         sensitivity = -0.5
    #     }

    #     # Example windowrule v1
    #     # windowrule = float, ^(kitty)$
    #     # Example windowrule v2
    #     # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    #     # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    #   # '';
    # extraConfig = ''

    #   exec-once = swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &
    #   exec-once = sleep 1 && swaylock

    #   input {
    #     kb_layout = us
    #     numlock_by_default = true
    #     follow_mouse = 1
    #     sensitivity = 0
    #   }

    #   misc {
    #     disable_autoreload = true
    #     disable_hyprland_logo = true
    #     always_follow_on_dnd = true
    #     layers_hog_keyboard_focus = true
    #     animate_manual_resizes = false
    #     enable_swallow = true
    #     # swallow_regex =
    #     focus_on_activate = true
    #   }

    #   general {
    #     layout = dwindle

    #     gaps_in = 5
    #     gaps_out = 10
    #     border_size = 2
    #     col.active_border = rgb(cba6f7) rgb(94e2d5) 45deg
    #     col.inactive_border = 0x00000000
    #     border_part_of_window = false
    #   }

    #   dwindle {
    #     no_gaps_when_only = false
    #     force_split = 0
    #     special_scale_factor = 1.0
    #     split_width_multiplier = 1.0
    #     use_active_for_splits = true
    #     pseudotile = yes
    #     preserve_split = yes
    #   }

    #   master {
    #     new_is_master = true
    #     special_scale_factor = 1
    #     no_gaps_when_only = false
    #   }

    #   decoration {
    #     rounding = 12

    #     active_opacity = 0.90;
    #     inactive_opacity = 0.90;
    #     fullscreen_opacity = 1.0;

    #     blur {
    #       enabled = true

    #       size = 3
    #       passes = 3

    #       brightness = 1
    #       contrast = 1.300000
    #       ignore_opacity = true
    #       noise = 0.011700

    #       new_optimizations = true

    #       xray = true
    #     }

    #     drop_shadow = true;

    #     shadow_ignore_window = true;
    #     shadow_offset = 0 2
    #     shadow_range = 20
    #     shadow_render_power = 3
    #     col.shadow = rgba(00000055)
    #   }

    #   # ----------------------------------------------------------------

    #   # show keybinds list
    #   bind = $mainMod, F1, exec, show-keybinds

    #   # keybindings
    #   bind = $mainMod, Return, exec, kitty
    #   bind = ALT, Return, exec, kitty --title float_kitty
    #   bind = $mainMod SHIFT, Return, exec, kitty --start-as=fullscreen -o 'font_size=16'
    #   bind = $mainMod, B, exec, firefox
    #   bind = $mainMod, Q, killactive,
    #   bind = $mainMod, F, fullscreen, 0
    #   bind = $mainMod SHIFT, F, fullscreen, 1
    #   bind = $mainMod, Space, togglefloating,
    #   bind = $mainMod, D, exec, pkill wofi || wofi --show drun
    #   bind = $mainMod, Escape, exec, swaylock
    #   bind = $mainMod SHIFT, Escape, exec, shutdown-script
    #   bind = $mainMod, P, pseudo,
    #   bind = $mainMod, J, togglesplit,
    #   bind = $mainMod, E, exec, nemo
    #   bind = $mainMod SHIFT, B, exec, pkill -SIGUSR1 .waybar-wrapped
    #   bind = $mainMod, C ,exec, hyprpicker -a
    #   bind = $mainMod, G,exec, $HOME/.local/bin/toggle_layout
    #   bind = $mainMod, W,exec, pkill wofi || wallpaper-picker

    #   # window control
    #   bind = $mainMod SHIFT, left, movewindow, l
    #   bind = $mainMod SHIFT, right, movewindow, r
    #   bind = $mainMod SHIFT, up, movewindow, u
    #   bind = $mainMod SHIFT, down, movewindow, d
    #   bind = $mainMod CTRL, left, resizeactive, -80 0
    #   bind = $mainMod CTRL, right, resizeactive, 80 0
    #   bind = $mainMod CTRL, up, resizeactive, 0 -80
    #   bind = $mainMod CTRL, down, resizeactive, 0 80
    #   bind = $mainMod ALT, left, moveactive,  -80 0
    #   bind = $mainMod ALT, right, moveactive, 80 0
    #   bind = $mainMod ALT, up, moveactive, 0 -80
    #   bind = $mainMod ALT, down, moveactive, 0 80

    #   # mouse binding
    #   bindm = $mainMod, mouse:272, movewindow
    #   bindm = $mainMod, mouse:273, resizewindow

    #   # windowrule
    #   windowrule = float,audacious
    #   windowrule = workspace 8 silent, audacious
    #   windowrule = pin,wofi
    #   windowrule = float,wofi
    #   windowrule = noborder,wofi
    #   windowrule = tile, neovide
    #   windowrule = idleinhibit focus,mpv
    #   windowrule = float,udiskie
    #   windowrule = float,title:^(Transmission)$
    #   windowrule = float,title:^(Volume Control)$
    #   windowrule = float,title:^(Firefox — Sharing Indicator)$
    #   windowrule = move 0 0,title:^(Firefox — Sharing Indicator)$
    #   windowrule = size 700 450,title:^(Volume Control)$
    #   windowrule = move 40 55%,title:^(Volume Control)$
    #   windowrulev2 = float, title:^(Picture-in-Picture)$
    #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$
    #   # windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*YouTube.*)$
    #   windowrulev2 = pin, title:^(Picture-in-Picture)$
    #   windowrule = float,imv
    #   windowrule = center,imv
    #   windowrule = size 1200 725,imv
    #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*imv.*)$
    #   windowrule = float,mpv
    #   windowrule = center,mpv
    #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*mpv.*)$
    #   windowrule = tile,Aseprite
    #   windowrulev2 = opacity 1.0 override 1.0 override, class:(Aseprite)
    #   windowrulev2 = opacity 1.0 override 1.0 override, class:(Unity)
    #   windowrule = size 1200 725,mpv
    #   windowrulev2 = idleinhibit focus, class:^(mpv)$
    # windowrulev2 = idleinhibit fullscreen, class:^(firefox)$

    #   windowrule = float,title:^(float_kitty)$
    #   windowrule = center,title:^(float_kitty)$
    #   windowrule = size 950 600,title:^(float_kitty)$

    #   windowrulev2 = float,class:^(pavucontrol)$
    #   windowrulev2 = float,class:^(SoundWireServer)$
    #   windowrulev2 = float,class:^(file_progress)$
    #   windowrulev2 = float,class:^(confirm)$
    #   windowrulev2 = float,class:^(dialog)$
    #   windowrulev2 = float,class:^(download)$
    #   windowrulev2 = float,class:^(notification)$
    #   windowrulev2 = float,class:^(error)$
    #   windowrulev2 = float,class:^(confirmreset)$
    #   windowrulev2 = float,title:^(Open File)$
    #   windowrulev2 = float,title:^(branchdialog)$
    #   windowrulev2 = float,title:^(Confirm to replace files)$
    #   windowrulev2 = float,title:^(File Operation Progress)$
    # '';
  };
}
