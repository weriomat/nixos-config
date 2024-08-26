{inputs, ...}: {
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # we dont have to disable anything since it is disables by default

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };
  home = {
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
}
