_: {
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = ["-F" "-H" "--group-directories-first" "--color=always"];
    git = true;
    icons = true;
  };
}
