{
  inputs,
  pkgs,
  ...
}:
{
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # we dont have to disable anything since it is disables by default
  kitty.enable = true;

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };
  home = {
    packages = [ pkgs.ripgrep ];
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
}
