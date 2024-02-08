{
  pkgs,
  lib,
  ...
}: {
  # keep in mind that this is the inport for both darwin and linux
  # imports = [ ./apps ./terminal ./gaming ];
  imports = [./apps ./terminal];
  discord.enable = lib.mkIf pkgs.stdenv.isLinux true;
  firefox.enable = lib.mkIf pkgs.stdenv.isLinux true;
  my_gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;
  my_mako.enable = lib.mkIf pkgs.stdenv.isLinux true;
  swaylock.enable = lib.mkIf pkgs.stdenv.isLinux true;
  wofi.enable = lib.mkIf pkgs.stdenv.isLinux true;
  waybar.enable = lib.mkIf pkgs.stdenv.isLinux true;
  hyprland.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home =
    if pkgs.stdenv.isLinux
    then {
      username = "marts";
      homeDirectory = "/home/marts";
      stateVersion = "23.11";
      packages =
        builtins.attrValues (import ./scripts/scripts.nix {inherit pkgs;});
    }
    else {
      stateVersion = "23.11";
      sessionVariables = {
        # EDITOR = "emacs";
      };
      file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };
      packages = [
        # overlays -> e.g just install one nerd font
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # write shell script like this
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ];
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
