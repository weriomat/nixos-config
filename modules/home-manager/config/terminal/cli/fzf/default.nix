_: {
  # TODO: configure more -> tmux and things
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    changeDirWidgetCommand = "fd --type d"; # <alt> + c
    changeDirWidgetOptions = [
      "--preview 'eza --tree {} | head -200'"
    ];

    defaultCommand = "fd --type f"; # fzf
    # catppuccin mocha
    defaultOptions = [
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      "--color=selected-bg:#45475a"
      "--multi"

      "--height 40%"
      "--border"
    ];

    fileWidgetCommand = "fd --type f"; # <ctrl> + t
    fileWidgetOptions = ["--preview 'bat --color=always --style=numbers --line-range=:500 {}'"];

    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [
        "-d 40%"
      ];
    };
  };
}
