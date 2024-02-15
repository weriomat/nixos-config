_: {
  programs.btop = {
    enable = true;
    settings = {
      # does not support all color schemes -> so no nix-colors
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
    };
  };
}
