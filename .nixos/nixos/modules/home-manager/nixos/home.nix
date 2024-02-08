{
  pkgs,
  inputs,
  ...
}: {
  # imports = [ ./apps ./terminal ./gaming ];
  # imports = [ ./apps ./terminal ];
  imports = [./apps];
  discord.enable = true;
  firefox.enable = true;
  hyprland.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home = {
    username = "marts";
    homeDirectory = "/home/marts";
    stateVersion = "23.11";
    packages =
      builtins.attrValues (import ./scripts/scripts.nix {inherit pkgs;});
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
