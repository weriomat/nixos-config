_: {
  # TODO: configure more -> tmux and things
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # TODO
    # colors = {};
    defaultCommand = "fd --type f";
  };
}
