{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.kitty
      else pkgs.unstable.kitty;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    settings = {
      # tab bar janked from https://github.com/catppuccin/kitty
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # janked from cobalts config
      # strip_trailing_space = "smart";
      cursor_shape = "beam";
      cursor_blink_interval = "1.0";
      cursor_stop_blinking_after = "15.0";

      scrollback_lines = 500000;
      # Colors (adapted from: https://github.com/kdrag0n/base16-kitty/blob/master/templates/default-256.mustache)
      # background = "#${config.colorScheme.palette.base00}";
      # foreground = "#${config.colorScheme.palette.base05}";
      # selection_background = "#${config.colorScheme.palette.base05}";
      # selection_foreground = "#${config.colorScheme.palette.base00}";
      # url_color = "#${config.colorScheme.palette.base04}";
      # cursor = "#${config.colorScheme.palette.base05}";
      # active_border_color = "#${config.colorScheme.palette.base03}";
      # inactive_border_color = "#${config.colorScheme.palette.base01}";
      # active_tab_background = "#${config.colorScheme.palette.base00}";
      # active_tab_foreground = "#${config.colorScheme.palette.base05}";
      # inactive_tab_background = "#${config.colorScheme.palette.base01}";
      # inactive_tab_foreground = "#${config.colorScheme.palette.base04}";
      # tab_bar_background = "#${config.colorScheme.palette.base01}";

      # # normal
      # color0 = "#${config.colorScheme.palette.base00}";
      # color1 = "#${config.colorScheme.palette.base08}";
      # color2 = "#${config.colorScheme.palette.base0B}";
      # color3 = "#${config.colorScheme.palette.base0A}";
      # color4 = "#${config.colorScheme.palette.base0D}";
      # color5 = "#${config.colorScheme.palette.base0E}";
      # color6 = "#${config.colorScheme.palette.base0C}";
      # color7 = "#${config.colorScheme.palette.base05}";

      # # bright
      # color8 = "#${config.colorScheme.palette.base03}";
      # color9 = "#${config.colorScheme.palette.base08}";
      # color10 = "#${config.colorScheme.palette.base0B}";
      # color11 = "#${config.colorScheme.palette.base0A}";
      # color12 = "#${config.colorScheme.palette.base0D}";
      # color13 = "#${config.colorScheme.palette.base0E}";
      # color14 = "#${config.colorScheme.palette.base0C}";
      # color15 = "#${config.colorScheme.palette.base07}";

      # # extended base16 colors
      # color16 = "#${config.colorScheme.palette.base09}";
      # color17 = "#${config.colorScheme.palette.base0F}";
      # color18 = "#${config.colorScheme.palette.base01}";
      # color19 = "#${config.colorScheme.palette.base02}";
      # color20 = "#${config.colorScheme.palette.base04}";
      # color21 = "#${config.colorScheme.palette.base06}";
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    font = {
      # IBM Plex mono with nerd font addons
      name = "'BlexMono Nerd Font'";
      # name = "'Iosevka Comfy'";
      size = 16;
      # package = pkgs.iosevka-comfy.comfy;
      package = pkgs.nerdfonts.override {fonts = ["IBMPlexMono"];};
    };
  };
}
