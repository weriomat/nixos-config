# to get helix runnin in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    helix

    cmake-language-server # cmake
    marksman # markdown
    lua-language-server # lua
    texlab # LaTeX
    # TODO: fix this cuz of darwin
    # unstable.perlnavigator # perl
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
    # haskell-language-server # haskell
    rust-analyzer # rust
    nil # nix

    # python
    ruff-lsp
    black
    nodePackages_latest.pyright
    # (pkgs.python3.withPackages (p: with p; [ python-lsp-server ]))
  ];

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
          args = ["--unique" "file:%p#src:%l%f"];
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
        language-server.ruff = {
          command = "ruff-lsp";
          config.settings = {args = ["--ignore" "E501"];};
        };
        langugage-server.pyright.config.analysis = {
          typeCheckingMode = "basic";
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
        # TODO: use nil and alejandra -> no differnece when using nix fmt
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "nixfmt";};
          language-servers = ["nil"];
        }
        {
          name = "go";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["ruff" "pyright"];
          auto-format = true;
          formatter = {
            command = "black";
            args = ["--line-length" "88" "--quiet" "-"];
          };
        }
      ];
    };
    # catppuccin.enable = true;
    settings = {
      theme = "${lib.strings.concatMapStringsSep "_" (x: lib.toLower x)
        (lib.strings.splitString " " (config.colorScheme.name))}";
      editor = {
        auto-save = true;
        bufferline = "always";
        line-number = "relative";
        true-color = true;

        # idle timeout
        idle-timeout = 5;
        lsp = {display-messages = true;};
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };

      keys.normal = {
        space.w = ":w";
        space.q = ":q";
        "{" = "goto_prev_paragraph";
        "}" = "goto_next_paragraph";
      };
    };
  };
}
