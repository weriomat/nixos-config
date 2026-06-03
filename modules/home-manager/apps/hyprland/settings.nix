{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my_hyprland;
in
{
  # FIXME: remove all default values from config
  wayland.windowManager.hyprland.settings = mkIf cfg.enable {
    decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
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

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
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
