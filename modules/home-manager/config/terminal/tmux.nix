{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    aggressiveResize = true; # resize window to the smalles session for which is in the current window
    clock24 = true;
    # customPaneNavigationAndResize
    disableConfirmationPromt = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    # nesSession -> create a new session if none is running
    plugins = [];
    prefix = "C-a"; # prefix key
    shortcut = "a";
    terminal = "screen-256color";

    # plugins
    # tmuxinator.enable
    # tmuxp.enable
    # tofi.enable = {
    #   package = pkgs.tofi;
    #   settings = {};
    # };
    tobgrade.enable = {};

    # zsh shell
    shell = "${pkgs.zsh}/bin/zsh";

    # to decide
    secureSocket = false;

    # default
    sensibleOnTop = true;
    escapeTime = 500;
    reverseSplit = false;
    resizeAmount = 5;

    # extraConfig
  };
}
