{
  pkgs,
  inputs,
  ...
}: {
  discord.enable = true;
  firefox.enable = true;
  hyprland.enable = false;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  home = {
    username = "marts";
    homeDirectory = "/home/marts";
    stateVersion = "23.11";
    packages = builtins.attrValues (import ../config/scripts {inherit pkgs;});
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
