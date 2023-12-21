{ pkgs, ... }: {
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [ "--group-directories-first" "--color=always" ];
    git = true;
    # icons = true;
  };
}
