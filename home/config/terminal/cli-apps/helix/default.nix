# to get helix runnin in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  home.packages = with pkgs; [
    helix
    cmake-language-server # cmake
    lua-language-server # lua
    taplo # toml
    delve # go debugger
    gopls # go lsp
    nodePackages.bash-language-server # bash
    yaml-language-server # yaml
    pyright # python
  ];
  # TODO: https://gitlab.com/hmajid2301/nixicle/-/blob/main/modules/home/cli/terminals/kitty/default.nix

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server = {
        rust-analyzer = {
          # stolen from https://github.com/poliorcetics/dotfiles/blob/main/home/helix/languages.nix
          # assist.importGranularity = "module";
          # cargo.extraEnv."CARGO_TARGET_DIR" = "${config.xdg.cacheHome}/rust-analyzer-target-dir";
          check.command =
            if pkgs.stdenv.isDarwin
            then "clippy"
            else "${pkgs.clippy}/bin/clippy";
          completion.fullFunctionSignatures.enable = true;
          hover.actions.references.enable = true;
          # lens.references = {
          #   adt.enable = true;
          #   enumVariant.enable = true;
          #   method.enable = true;
          #   trait.enable = true;
          # };

          inlayHints = {
            closingBraceHints.minLines = 10;
            closureReturnTypeHints.enable = "with_block";
            discriminantHints.enable = "fieldless";
            lifetimeElisionHints.enable = "skip_trivial";
            # typeHints.hideClosureInitialization = false;
            # Reborrows and such
            expressionAdjustmentHints = {
              enable = "never";
              hideOutsideUnsafe = false;
              mode = "prefer_prefix";
            };
          };

          # I have beefy machines, let's use them
          lruCapacity = 256;
          workspace.symbol.search = {
            limit = 128;
            kind = "all_symbols";
            scope = "workspace";
          };

          # diagnostics.disabled = [
          #   "inactive-code"
          #   "inactive_code"
          #   "unresolved-proc-macro"
          #   "unresolved_proc_macro"
          # ];
        };
        ruff = {
          command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
          config.settings = {args = ["--ignore" "E501"];};
        };

        pyright.config.analysis = {
          typeCheckingMode = "basic";
        };

        # NOTE: LaTeX
        texlab = {
          command = "${pkgs.texlab}/bin/texlab";
          auxDirectory = "auz";
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = "${pkgs.okular}/bin/okular";
            args = ["--unique" "file:%p#src:%l%f"];
          };

          build = {
            forwardSearchAfter = true;
            onSave = true;

            executable = "${pkgs.texlive.withPackages (ps: [ps.latexmk])}/bin/latexmk";
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

        # LTeX LSP for grammar and spellchecking
        ltex = {
          command = pkgs.ltex-ls + "/bin/ltex-ls";
          config.ltex = {
            completionEnabled = true;
            ltex-ls.logLevel = "warning";
            server.trace = "off";
            statusBarItem = false;

            # since we have languagetool running on localhost we can set this here, only on linux tho
            languageToolHttpServerUri = mkIf pkgs.stdenv.isLinux "http://localhost:8081";

            language = "auto";
            additionalRules.enablePickyRules = true;
            disabledRules.en-US = [
              "EN_QUOTES"
              "UPPERCASE_SENTENCE_START"
            ];
          };
        };

        nixd = {
          # TODO: here
          # nil # nix
          # nixd # nix
          command = "${pkgs.nixd}/bin/nixd";
          # nixpkgs.expr = "import (builtins.getFlake \"/home/brisingr05/nixos-config\").inputs.nixpkgs { }";
          # formatting.command = ["nixfmt"]; # Currently doesn't work
          # options.nixos.expr = "(builtins.getFlake \"/home/brisingr05/nixos-config\").nixosConfigurations.hpaio.options";
        };

        # markdown
        marksman = {
          command = "${pkgs.marksman}/bin/marksman";
        };

        clangd.args = ["--enable-config"];
      };

      language = [
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "cpp";
          auto-format = true;
        }

        {
          name = "markdown";
          auto-format = true;
          language-servers = [
            "marksman"
            "ltex"
          ];
          formatter = {
            command = "${pkgs.dprint}/bin/dprint";
            args = let
              config = pkgs.writeText "config.json" ''
                {
                  "markdown": {
                    "lineWidth":120,
                  },
                  "excludes": [],
                  "plugins": [
                    "https://plugins.dprint.dev/markdown-0.17.8.wasm"
                  ]
                }
              '';
            in ["fmt" "--config" "${config}" "--stdin" "md"];
          };
          rulers = [120];
        }
        {
          name = "haskell";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
            args = ["-q"];
          };
          # NOTE: removed nil
          language-servers = ["nixd"];
        }
        {
          name = "go";
          auto-format = true;
        }
        {
          name = "latex";
          auto-format = true;
          language-servers = [
            "texlab"
            "ltex"
          ];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["ruff" "pyright"];
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = ["--line-length" "88" "--quiet" "-"];
          };
        }
      ];
    };

    catppuccin = {
      enable = true;
      flavor = "mocha";
      useItalics = true;
    };

    settings = {
      editor = {
        # auto-save = true;
        bufferline = "always";
        line-number = "relative";
        true-color = true;

        idle-timeout = 5;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = true;
          git-ignore = true;
        };
      };

      keys.normal = {
        # TODO: lazygit
        space = {
          w = ":w";
          q = ":q";
          G = ":sh kitty @ launch --no-response --type=overlay --cwd $(pwd) --title gl lazygit";
        };
        "{" = "goto_prev_paragraph";
        "}" = "goto_next_paragraph";
        # better window naivgation
        # TODO: fix this
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";
      };
    };
  };
}
