_: {
  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # NOTE: this uses unstable packages
    nix-index-database.comma.enable = true;
  };

  # set picker per default to fzf
  home.sessionVariables = {
    COMMA_PICKER = "fzf";
  };
}
