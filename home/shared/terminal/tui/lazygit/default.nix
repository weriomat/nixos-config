{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  catppuccin.lazygit = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # Git helper
  programs = {
    lazygit.enable = true;
    zsh.shellAliases.gl = getExe pkgs.lazygit;
  };
}
