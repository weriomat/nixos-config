{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    # TODO: fix use overlay for macos
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.kitty
      else pkgs.unstable.kitty;
    theme = "Catppuccin-Mocha";
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

      scrollback_lines = 5000;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    font = {
      # IBM Plex mono with nerd font addons
      name = "'BlexMono Nerd Font'";
      # name = "'Iosevka Comfy'";
      # name = "'Iosevka Comfy'";
      size = 16;
      # package = pkgs.iosevka-comfy.comfy;
      package = pkgs.nerdfonts.override {fonts = ["IBMPlexMono"];};
    };
  };
}
