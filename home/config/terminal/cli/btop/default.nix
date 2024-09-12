{lib, ...}: {
  programs.btop = {
    enable = true;

    # is beeing overwritten
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    settings = {
      color_theme = lib.mkForce "gruvbox_dark_v2";
      vim_keys = true;
    };
  };
}
