{...}: {
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = ["-F" "-H" "--group-directories-first" "--color=always"];
    git = true;
    icons = true;
  };
}
