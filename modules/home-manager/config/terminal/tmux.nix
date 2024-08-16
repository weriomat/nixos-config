{
  inputs,
  pkgs,
  globals,
  ...
}: {
  programs.tmux = {
    enable = true;
    aggressiveResize = true; # resize window to the smalles session for which is in the current window
    clock24 = true;
    # customPaneNavigationAndResize
    disableConfirmationPrompt = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    # nesSession -> create a new session if none is running

    prefix = "C-a"; # prefix key
    shortcut = "a";
    terminal = "tmux-256color";

    # plugins both are session manager
    tmuxinator.enable = true;

    # zsh shell
    shell = "${pkgs.zsh}/bin/zsh";

    # to decide
    secureSocket = false;

    # default
    escapeTime = 0;
    reverseSplit = false;
    resizeAmount = 5;

    # TODO: set default-command

    sensibleOnTop = true;
    plugins = with pkgs; [
      {
        plugin = inputs.sessionx.packages.${globals.architekture}.default;
        extraConfig = ''
          set -g @sessionx-auto-accept 'off'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'off'
          set -g @sessionx-custom-paths-subdirectories 'false'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-path '~/.nixos/nixos'
          # Tmuxinator mode on
          set -g @sessionx-tmuxinator-mode 'on'
        '';
      }
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          # fzf url
          set -g @fzf-url-history-limit '10000'
        '';
      }
      {
        plugin = tmuxPlugins.fuzzback;
        extraConfig = ''
          # fuzzback
          set -g @fuzzback-bind I
          set -g @fuzzback-popup 1
        '';
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%H:%M"

          set -g @catppuccin_pane_border_style "fg=#{thm_gray}" # Use a value compatible with the standard tmux 'pane-border-style'
          set -g @catppuccin_pane_active_border_style "fg=#{thm_orange}" # Use a value compatible with the standard tmux 'pane-border-active-style'
        '';
      }
      {plugin = tmuxPlugins.vim-tmux-navigator;}
      {plugin = tmuxPlugins.yank;}
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    # <pref + I> install packages with tmp
    extraConfig = ''
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style

      bind R source-file ~/.config/tmux/tmux.conf

      # open new panes under current path
      # bind '"' split-window -v -c "#{pane_current_path}"
      # bind % split-window -h -c "#{pane_current_path}"
      # Change splits to match nvim and easier to remember
      # Open new split at cwd of current split
      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"


      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
