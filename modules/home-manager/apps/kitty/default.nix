{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.kitty.enable = mkEnableOption "Enable my kitty options";

  # TODO: broewser : https://github.com/chase/awrit
  # TODO: take a look at shortcuts
  # TODO: windows
  config = mkIf config.kitty.enable {
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, K, exec, ${config.programs.kitty.package}/bin/kitty"
    ];

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

      # TODO: take a look at https://github.com/nix-community/home-manager/blob/master/modules/programs/kitty.nix
      # shellIntegration.zshIntegration = true;

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
      };

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+shift+t" = "new_tab_with_cwd";
        # Vim movement in windows
        "ctrl+h" = "neighboring_window left";
        "ctrl+l" = "neighboring_window right";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        # prev active window
        "ctrl+p" = "nth_window -1";
        # window layouts
        "ctrl+a" = "enabled_layouts horizontal";
        "ctrl+x" = "enabled_layouts stack";
        # resizing
        "ctrl+left" = "resize_window narrower";
        "ctrl+right" = "resize_window wider";
        "ctrl+up" = "resize_window taller";
        "ctrl+down" = "resize_window shorter 3";
        # reset all windows in the tab to default sizes
        "ctrl+home" = "resize_window reset";
      };
    };
  };
}
