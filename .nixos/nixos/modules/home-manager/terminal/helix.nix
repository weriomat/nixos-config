# helix config
# to get helix runnin in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    helix

    cmake-language-server # cmake
    marksman # markdown
    lua-language-server # lua
    texlab # LaTeX
    unstable.perlnavigator # perl
    metals # scala
    taplo # toml
    delve # go debugger
    gopls # go lsp
    rubyPackages.solargraph # ruby
    nodePackages.vscode-html-languageserver-bin # HTML
    nodePackages.typescript-language-server # TS, TSX and JSX
    nodePackages.vscode-css-languageserver-bin # css + scss
    nodePackages.bash-language-server # bash
    nodePackages.vls # vuejs
    haskell-language-server # haskell
    rust-analyzer # rust
    nil # nix
  ];
  # programs.helix.enable = true;
  # programs.helix.settings = {
  # keys.normal = {
  # space.w = ":w";
  # space.q = ":q";
  # };
  # editor = {
  # line-number = "relative";
  # lsp.display-messages = true;
  # };
  # keys.normal = {
  # space.space = "file_picker";
  # space.w = ":w";
  # space.q = ":q";
  # esc = [ "collapse_selection" "keep_primary_selection" ];
  # };
  # };
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server.texlab = {
        auxDirectory = "auz";
        chktex = {
          onOpenAndSave = true;
          onEdit = true;
        };
        forwardSearch = {
          executable = "okular";
          args = [ "--unique" "file:%p#src:%l%f" ];
        };

        build = {
          forwardSearchAfter = true;
          onSave = true;

          executable = "latexmk";
          args = [
            "-pdf"
            "-interaction=nonstopmode"
            "-synctex=1"
            "-shell-escape"
            "-output-directory=build"
            "%f"
          ];
        };
      };

      language = [
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "haskell";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = { command = "nixfmt"; };
        }
        {
          name = "go";
          auto-format = true;
        }
      ];
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        auto-save = true;
        bufferline = "always";
        line-number = "relative";
        true-color = true;
      };
      # "editor" = {
      # cursor-shape.insert = "bar";
      # indent-guides.render = true;
      # };
      # editor.statusline = {
      # left = ["mode", "spinner", "read-only-indicator", "file-modification-indicator"];
      # center = ["file-name"];
      # right = ["diagnostics", "version-control", "selections", "position", "file-encoding", "file-line-ending"];
      # };
      editor.lsp = { display-messages = true; };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      keys.normal = {
        space.w = ":w";
        space.q = ":q";
      };
    };
    # themes = {
    # catppuccin-mocha = lib.trivial.importTOML
    # (pkgs.martsPackages.helix-catppuccin + "/helix/catppuccin_mocha.toml");
    # };
  };

}
