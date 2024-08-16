_: {
  # TODO: configure more -> tmux and things
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    changeDirWidgetCommand = "fd --type d"; # <alt> + c
    changeDirWidgetOptions = [
      "--preview 'eza --tree {} | head -200'"
    ];

    defaultCommand = "fd --type f"; # fzf
    # catppuccin mocha
    defaultOptions = [
      "--multi"

      "--height 40%"
      "--border"
      "--bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'"
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
