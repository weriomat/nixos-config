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

  xwayland = { force_zero_scaling = true },

  dwindle = { preserve_split = true, },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})
