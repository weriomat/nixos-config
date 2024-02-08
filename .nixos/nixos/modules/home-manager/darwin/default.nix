{...}: {
  home = {
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
  programs.home-manager.enable = true;
}
