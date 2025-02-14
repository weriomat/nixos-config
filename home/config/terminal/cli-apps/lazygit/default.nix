{ pkgs, ... }:
{
  catppuccin.lazygit = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # Git helper
  programs = {
    lazygit.enable = true;
    zsh.shellAliases = {
      gl = "${pkgs.lazygit}/bin/lazygit";
    };
  };

}
