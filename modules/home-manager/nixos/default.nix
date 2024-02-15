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

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home = rec {
    username = "marts";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11"; # Has not to be changed
    packages = builtins.attrValues (import ../config/scripts {inherit pkgs;});
  };

  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')
  # ];

  # home.file = {
  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';
  # };

  # home.sessionVariables = {
  # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
