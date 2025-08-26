# to get helix running in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{
  lib,
  pkgs,
  ...
}:
let
  # TODO: https://github.com/tekumara/typos-lsp
  # https://github.com/tekumara/typos-lsp/blob/main/docs/helix-config.md
  inherit (lib) mkIf getExe getExe';
in
{
  home.packages = [
    pkgs.helix
    pkgs.cmake-language-server # cmake
    pkgs.lua-language-server # lua
    pkgs.taplo # toml
    pkgs.delve # go debugger
    pkgs.gopls # go lsp
    pkgs.nodePackages.bash-language-server # bash
    pkgs.yaml-language-server # yaml
    pkgs.pyright # python
    pkgs.terraform-ls # terraform lsp
    pkgs.jdt-language-server # java lsp
  ];

  catppuccin.helix = {
    enable = true;
    flavor = "mocha";
    useItalics = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server = {
        rust-analyzer = {
          # stolen from https://github.com/poliorcetics/dotfiles/blob/main/home/helix/languages.nix
          # assist.importGranularity = "module";
          # cargo.extraEnv."CARGO_TARGET_DIR" = "${config.xdg.cacheHome}/rust-analyzer-target-dir";
          # check.command = if pkgs.stdenv.isDarwin then "clippy" else "${pkgs.clippy}/bin/clippy";
          # config.checkOnSave.command = if pkgs.stdenv.isDarwin then "clippy" else "${pkgs.clippy}/bin/clippy";
          check.command = "${pkgs.clippy}/bin/clippy";
          config.checkOnSave.command = "${pkgs.clippy}/bin/clippy";

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
          command = "${pkgs.ruff}/bin/ruff";
          args = [
            "server"
            "--ignore"
            "E501"
          ];
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
            executable =
              if pkgs.stdenv.isDarwin then
                "${pkgs.evince}/bin/evince"
              else
                "${pkgs.kdePackages.okular}/bin/okular";
            args =
              if pkgs.stdenv.isDarwin then
                [
                  "-o"
                  "file:%p#src:%l%f"
                ]
              else
                [
                  "--unique"
                  "file:%p#src:%l%f"
                ];
          };

          build = {
            forwardSearchAfter = true;
            onSave = true;

            executable = "${pkgs.texlive.withPackages (ps: [ ps.latexmk ])}/bin/latexmk";
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
          command = getExe pkgs.ltex-ls;
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
        marksman.command = "${pkgs.marksman}/bin/marksman";

        clangd.args = [ "--enable-config" ];

        terraform-ls = {
          command = "${pkgs.terraform-ls}/bin/terraform-ls";
          args = [ "serve" ];
        };
      };

      language = [
        {
          name = "hcl";
          auto-format = true;
          formatter = {
            command = "${pkgs.opentofu}/bin/tofu";
            args = [ "fmt -" ];
          };
          language-servers = [ "terraform-ls" ];
        }
        {
          name = "java";
          auto-format = true;
          formatter = {
            command = "${getExe pkgs.google-java-format}";
            args = [
              "-a"
              "-"
            ];
          };
        }
        {
          name = "tfvars";
          auto-format = true;
          formatter = {
            command = "${pkgs.opentofu}/bin/tofu";
            args = [ "fmt -" ];
          };
          language-servers = [ "terraform-ls" ];
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "${getExe pkgs.taplo}";
            args = [
              "fmt"
              "-"
            ];
          };
        }
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
            args =
              let
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
              in
              [
                "fmt"
                "--config"
                "${config}"
                "--stdin"
                "md"
              ];
          };
          rulers = [ 120 ];
        }
        {
          name = "haskell";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            args = [ "-q" ];
          };
          # NOTE: removed nil
          language-servers = [ "nixd" ];
        }
        {
          name = "go";
          auto-format = true;
        }
        {
          name = "bibtex";
          auto-format = true;
          formatter.command = getExe pkgs.bibtex-tidy;
        }
        {
          name = "latex";
          auto-format = true;
          language-servers = [
            "texlab"
            "ltex"
          ];
          formatter = {
            command = getExe' pkgs.texlivePackages.latexindent "latexindent";
            # TODO: so that no indent.log is displayed
            # args = [
            #   "-g /dev/null"
            # ];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "ruff"
            "pyright"
          ];
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = [
              "--line-length"
              "88"
              "--quiet"
              "-"
            ];
          };
        }
      ];
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
        space = {
          w = ":w";
          q = ":q";
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
