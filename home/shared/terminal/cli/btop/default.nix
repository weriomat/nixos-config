{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  # is been overwritten
  catppuccin.btop = {
    enable = true;
    flavor = "mocha";
  };
  programs.btop = {
    enable = true;

    settings = {
      color_theme = mkForce "gruvbox_dark_v2";
      vim_keys = true;
    };
  };
}
