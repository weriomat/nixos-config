# to get helix running in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
in
{
  home.packages = [
    pkgs.cmake-language-server # cmake
    pkgs.neocmakelsp
    pkgs.lua-language-server # lua
    pkgs.taplo # toml
    pkgs.delve # go debugger
    pkgs.gopls # go lsp
    pkgs.nodePackages.bash-language-server # bash
    pkgs.yaml-language-server # yaml
    pkgs.pyright # python
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
          check.command = getExe pkgs.clippy;
          config.checkOnSave.command = getExe pkgs.clippy;

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
          command = getExe pkgs.ruff;
          args = [
            "server"
            "--ignore"
            "E501"
          ];
        };

        codebook = {
          command = lib.getExe pkgs.codebook;
          args = [ "serve" ];
        };

        pyright.config.analysis.typeCheckingMode = "basic";

        tinymist = {
          command = getExe pkgs.tinymist;
          config.preview.background.enabled = true;
        };

        # NOTE: LaTeX
        texlab = {
          command = getExe pkgs.texlab;
          auxDirectory = "auz";
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = if pkgs.stdenv.isDarwin then getExe pkgs.evince else getExe pkgs.kdePackages.okular;
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

            executable = getExe' (pkgs.texlive.withPackages (ps: [ ps.latexmk ])) "latexmk";
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
          command = getExe pkgs.nixd;
          options.nixos.expr = "(builtins.getFlake \"${config.programs.nh.flake}\").nixosConfigurations.<name>.options";
        };

        # markdown
        marksman.command = getExe pkgs.marksman;

        clangd.args = [
          "--enable-config"
          "--clang-tidy"
          "--experimental-modules-support"
          "--background-index"
        ];

        tofu-ls = {
          command = getExe pkgs.tofu-ls;
          args = [ "serve" ];
        };

        typos = {
          command = getExe pkgs.typos-lsp;
          environment.RUST_LOG = "error";
          config.diagnosticSeverity = "Warning";
        };
      };

      language = [
        {
          name = "hcl";
          auto-format = true;
          formatter = {
            command = getExe pkgs.opentofu;
            args = [ "fmt -" ];
          };
          language-servers = [
            "tofu-ls"
            "codebook"
            "typos"
          ];
        }
        {
          name = "java";
          auto-format = true;
          formatter = {
            command = getExe pkgs.google-java-format;
            args = [
              "-a"
              "-"
            ];
          };
          language-servers = [
            "jdtls"
            "typos"
            "codebook"
          ];
        }
        {
          name = "tfvars";
          auto-format = true;
          formatter = {
            command = getExe pkgs.opentofu;
            args = [ "fmt -" ];
          };
          language-servers = [
            "tofu-ls"
            "typos"
            "codebook"
          ];
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = getExe pkgs.taplo;
            args = [
              "fmt"
              "-"
            ];
          };
          language-servers = [
            "taplo"
            "typos"
            "codebook"
          ];
        }
        {
          name = "c";
          auto-format = true;
          language-servers = [
            "clangd"
            "typos"
            "codebook"
          ];
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = [
            "clangd"
            "typos"
            "codebook"
          ];
        }

        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = getExe pkgs.dprint;
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
          language-servers = [
            "marksman"
            "ltex"
            "typos"
            "codebook"
          ];
        }
        {
          name = "haskell";
          auto-format = true;
          # TODO: lsp
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = getExe pkgs.nixfmt-rfc-style;
            args = [ "-q" ];
          };
          language-servers = [
            "nixd"
            "typos"
            "codebook"
          ];
        }
        {
          name = "go";
          auto-format = true;
          language-servers = [
            "gopls"
            "typos"
            "codebook"
          ];
        }
        {
          name = "bibtex";
          auto-format = true;
          formatter.command = getExe pkgs.bibtex-tidy;
        }
        {
          name = "latex";
          auto-format = true;
          formatter = {
            command = getExe' pkgs.texlivePackages.latexindent "latexindent";
            # TODO: so that no indent.log is displayed
            # args = [
            #   "-g /dev/null"
            # ];
          };
          language-servers = [
            "texlab"
            "ltex"
            "typos"
            "codebook"
          ];
        }
        {
          name = "typst";
          formatter.command = getExe pkgs.typstyle;
          language-servers = [
            "tinymist"
            "ltex"
            "typos"
            "codebook"
          ];
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = getExe pkgs.black;
            args = [
              "--line-length"
              "88"
              "--quiet"
              "-"
            ];
          };
          language-servers = [
            "ruff"
            "pyright"
            "typos"
            "codebook"
          ];
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

      # keep in mind that kitty will intercept inputs
      keys.normal = {
        "C-p" = '':lsp-workspace-command tinymist.pinMain "%sh{realpath %{buffer_name}}"''; # see https://forum.typst.app/t/what-is-the-best-setup-for-using-typst-in-helix-editor/5867/3
        "C-m" = ":lsp-workspace-command tinymist.startDefaultPreview";
        space = {
          w = ":w";
          q = ":q";
        };
        "{" = "goto_prev_paragraph";
        "}" = "goto_next_paragraph";
        # better window naivgation
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";
      };
    };
  };
}
