{
  pkgs,
  inputs,
  globals,
  ...
}: {
  discord.enable = true;
  firefox.enable = true;
  hyprland.enable =
    if globals.isLaptop
    then false
    else true;

  vscode.enable = true;
  kitty.enable = true;

  # TODO: gtk, hyprland, waybar
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home = rec {
    inherit (globals) username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11"; # Has not to be changed
    packages = builtins.attrValues (import ../config/scripts {inherit pkgs globals inputs;});
    # Add ./local/bin to $PATH
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
  };

  # home.sessionVariables = {
  # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
