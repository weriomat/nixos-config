_: {
  wayland.windowManager.hyprland.settings = {
    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      touchpad = {
        natural_scroll = "no";
      };

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    };
    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "$mauve $teal 45deg";
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

      # drop_shadow = true;
      # "col.shadow" = "rgba(00000055)";
      # shadow_ignore_window = true;
      # shadow_offset = "0 2";
      # shadow_range = 20;
      # shadow_render_power = 3;
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

    xwayland.force_zero_scaling = true;

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    dwindle = {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      # no_gaps_when_only = false;
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
      # new_is_master = true;
      special_scale_factor = 1;
      # no_gaps_when_only = false;
    };

    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    gestures.workspace_swipe = false;

    misc = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
      disable_hyprland_logo = true;
    };
  };

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
  #
  #   # Example per-device config
  #   # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
  #   device:epic-mouse-v1 {
  #       sensitivity = -0.5
  #   }
}
