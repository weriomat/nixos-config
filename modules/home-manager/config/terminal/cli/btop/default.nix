{lib, ...}: {
  programs.btop = {
    enable = true;

    # is beeing overwritten
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    settings = {
      # does not support all color schemes -> so no nix-colors
      color_theme = lib.mkForce "gruvbox_dark_v2";
      vim_keys = true;
    };
  };
}
