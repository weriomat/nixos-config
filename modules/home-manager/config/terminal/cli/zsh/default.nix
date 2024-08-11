{
  config,
  globals,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # TODO: fix vi keysbindings
    # Improved vim bindings.
    # Man without options will use fzf to select a page
    # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

    # function fzf-man(){
    #   MAN="/usr/bin/man"
    #   if [ -n "$1" ]; then
    #     $MAN "$@"
    #     return $?
    #   else
    #     $MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
    #     return $?
    #   fi
    # }
    # # set list-colors to enable filename colorizing
    # zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    envExtra = ''
      # # If not running interactively, don't do anything and return early
      # [[ -o interactive ]] || exit 0
      # Enable Ctrl+arrow key bindings for word jumping
      bindkey '^[[1;5C' forward-word     # Ctrl+right arrow
      bindkey '^[[1;5D' backward-word    # Ctrl+left arrow

      bindkey -v
      # set -o vi
      export KEYTIMEOUT=1

      # vi
      # TODO: fix
      # bindkey -M menuselect 'h' vi-backward-char
      # bindkey -M menuselect 'k' vi-up-line-or-history
      # bindkey -M menuselect 'l' vi-forward-char
      # bindkey -M menuselect 'j' vi-down-line-or-history

      # change cursor shape for different vi modes
      function zle-keymap-select() {
        case $KEYMAP in
          vimcd) echo -ne '\e[1 q';; # block
          viins|main) echo -ne '\e[5 q';; # beam
        esac
      }
      zle -N zle-keymap-select
      zle-line-init(){
        zle -K viins # init vi ins as keymap
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q' # use beam at startup
      preexec(){
        echo -ne '\e[5 q' ; # use beam for each new prompt
      }
    '';

    shellAliases = {
      diff = "diff --color";

      # grep
      grep = "grep --color=auto";
      ga = "git add";
      gb = "git branch";
      gc = "git commit -m";
      gco = "git checkout";
      gss = "git status -sb";
      gpp = "git push";
      gpu = "git pull";
      # lazygit
      gl = "lazygit";
      ssh = "TERM=xterm-256color /usr/bin/env ssh";

      # format nix flake
      format-flake = "cd $HOME/.nixos/nixos && nix fmt && cd -";

      # prettyping to ping default
      ping = "prettyping";

      df = "duf --all --theme dark";
      # alternative
      dig = "dog";

      # manix fzf
      ma = ''manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix'';
      raspi = "ssh -i ~/.ssh/id_ed25519 -p 2077 marts@192.168.178.21";
      # check nix flake
      check-flake = "cd $HOME/.nixos/nixos && nix flake check && cd -";

      test-update = "sudo nixos-rebuild test --flake /home/${globals.username}/.nixos/nixos#default";

      # nix shell
      nd = "nix develop -c zsh";
    };
    history = {
      size = 10000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "b06e7574577cd729c629419a62029d31d0565a7a";
          sha256 = "sha256-ilUavAIWmLiMh2PumtErMCpOcR71ZMlQkKhVOTDdHZw=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
# let cfg = config.system.shell;
#   options.system.shell = with types; {
#     shell = mkOpt (enum [ "nushell" "fish" ]) "nushell" "What shell to use";
#   };
#     environment.systemPackages = with pkgs; [ eza bat nitch zoxide starship ];
#       home.configFile."colors.conf" = {
#         target = "hexchat/colors.conf";
#         source = pkgs.fetchurl {
#           url = "https://raw.githubusercontent.com/catppuccin/hexchat/main/mocha/colors.conf";
#           sha256 = "sha256-EEJGpq+9okNP3kk6d17FEkxf2HlWkP082s5dfF1Dwwc=";
#         };
#     };
#     home.programs.hexchat = {
#       enable = true;
#       #theme = pkgs.fetchzip {
#       #url = "https://dl.hexchat.net/themes/Monokai.hct#Monokai.zip";
#       #sha256 = "sha256-WCdgEr8PwKSZvBMs0fN7E2gOjNM0c2DscZGSKSmdID0=";
#       #stripRoot = false;
#       #        source = pkgs.fetchurl {
#       #          url = "https://github.com/catppuccin/hexchat/archive/main/mocha/colors.conf.tar.gz";
#       #          sha256 = "sha256:1jia66vzy99izcwwqjcr54h6r3x0m675xmyfc0lgijqjlahiq5fv";
#       #        };
#       #source = pkgs.fetchFromGitHub {
#       #  owner = "catppuccin";
#       #  repo = "hexchat";
#       #  rev = "f84284c9d8363066d04c262717750cad623c1e8c";
#       #  sha256 = "sha256-2xUcoaISy/goYM7XXo6poI9sICmZScw5+zEl/7cxKso=";
#       #};
#     };
#     home.programs.zoxide = {
#       enable = true;
#       enableNushellIntegration = true;
#     };
#     home.extraOptions.programs.atuin = {
#       enable = false;
#       enableZshIntegration = true;
#     };
#     home.programs.zsh = {
#       enable = true;
#       autocd = true;
#       enableAutosuggestions = true;
#       enableCompletion = true;
#       defaultKeymap = "emacs";
#       syntaxHighlighting.enable = true;
#       shellAliases = { refresh = "source /home/${config.user.name}/.zshrc"; };
#       initExtraBeforeCompInit = ''
#         export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-mocha)"
#       '';
#       initExtra = # bash
#         ''
#           # Fix an issue with tmux.
#           export KEYTIMEOUT=1
#           # Use vim bindings.
#           set -o vi
#           # Improved vim bindings.
#           # Man without options will use fzf to select a page
#           zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
#           function fzf-man(){
#             MAN="/usr/bin/man"
#             if [ -n "$1" ]; then
#               $MAN "$@"
#               return $?
#             else
#               $MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
#               return $?
#             fi
#           }
#           # set list-colors to enable filename colorizing
#           zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
#         '';
#     };

