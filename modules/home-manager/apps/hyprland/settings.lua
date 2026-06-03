hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    layout = "dwindle",

    allow_tearing = false,

    col = {
      active_border = "rgb(cba6f7)",
      inactive_border = 0x00000000,
    },
  },

  input = {
      kb_layout = "us",
      kb_variant = "",
      kb_model = "",
      kb_options = "",
      kb_rules = "",

      follow_mouse = 1,
      sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false,
      },
  },

  xwayland = {
    force_zero_scaling = true
  },

  dwindle = {
    force_split            = 0,
    special_scale_factor   = 1,
    split_width_multiplier = 1.0,
    use_active_for_splits  = true,
    preserve_split         = true,

    -- smart_split                  = false,
    -- smart_resizing               = true,
    -- permanent_direction_override = false,
    -- default_split_ratio          = 1.0,
    -- split_bias                   = 0,
    -- precise_mouse_move           = false,
  },

  master = {
    special_scale_factor = 1,
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})
