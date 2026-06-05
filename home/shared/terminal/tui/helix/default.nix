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
  # pull snippets via `simple-completion-language-server fetch-external-snippets` && `simple-completion-language-server validate-snippets`
  xdg.configFile."helix/external-snippets.toml".text = ''
    [[sources]] 
    name = "friendly-snippets"  
    git = "https://github.com/rafamadriz/friendly-snippets.git" 
  '';

  home.packages = [ pkgs.simple-completion-language-server ];

  catppuccin.helix = {
    enable = true;
    flavor = "mocha";
    useItalics = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = [
      pkgs.cmake-language-server # cmake
      pkgs.neocmakelsp
      pkgs.lua-language-server # lua
      pkgs.taplo # toml
      pkgs.delve # go debugger
      pkgs.gopls # go lsp
      pkgs.bash-language-server # bash
      pkgs.yaml-language-server # yaml
      pkgs.pyright # python
      pkgs.jdt-language-server # java lsp
    ];

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

        pyright.config.analysis.typeCheckingMode = "basic";

        tinymist = {
          command = getExe pkgs.tinymist;
          config = {
            preview.background.enabled = true;
            lint.enabled = true;
            exportPdf = "onSave";
            formatterMode = "typstyle";
            formatterPrintWidth = 80;
          };
        };

        lua-language-server.command = getExe pkgs.lua-language-server;

        scls = {
          command = getExe pkgs.simple-completion-language-server;

          config = {
            max_completion_items = 20;
            snippets_first = true;

            feature_snippets = true;
            feature_unicode_input = true;
            feature_words = true;
          };

          environment = {
            RUST_LOG = "info,simple-completion-language-server=info";
            LOG_FILE = "/tmp/completion.log";
          };
        };

        # NOTE: LaTeX
        texlab = {
          command = getExe pkgs.texlab;
          config = {
            auxDirectory = "auz";
            chktex = {
              onOpenAndSave = true;
              onEdit = true;
            };
            forwardSearch = {
              executable = if pkgs.stdenv.isDarwin then getExe pkgs.zathura else getExe pkgs.kdePackages.okular;
              args =
                if pkgs.stdenv.isDarwin then
                  [
                    "--synctex-forward"
                    "%l:1:%f"
                    "%p"
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

              executable = "${getExe pkgs.tectonic}";
              args = [
                "-X"
                "build"
                "--synctex"
                "--keep-logs"
                "--keep-intermediates"
              ];
            };
          };
        };

        harper = {
          command = getExe' pkgs.harper "harper-ls";
          args = [ "--stdio" ];
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
            "typos"
            "scls"
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
            "scls"
            "harper"
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
            "scls"
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
            "scls"
            "harper"
          ];
        }
        {
          name = "c";
          auto-format = true;
          language-servers = [
            "clangd"
            "typos"
            "scls"
            "harper"
          ];
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = [
            "clangd"
            "typos"
            "scls"
            "harper"
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
            "scls"
            "harper"
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
            command = getExe pkgs.nixfmt;
            args = [ "-q" ];
          };
          language-servers = [
            "nixd"
            "typos"
            "scls"
            "harper"
          ];
        }
        {
          name = "go";
          auto-format = true;
          language-servers = [
            "gopls"
            "typos"
            "scls"
            "harper"
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
          formatter.command = getExe' pkgs.texlivePackages.latexindent "latexindent";
          language-servers = [
            "texlab"
            "ltex"
            "typos"
            "scls"
            "harper"
          ];
        }
        {
          name = "typst";
          auto-format = true;
          formatter.command = getExe pkgs.typstyle;
          language-servers = [
            "tinymist"
            "ltex"
            "typos"
            "scls"
            "harper"
          ];
        }
        {
          name = "lua";
          auto-format = true;
          formatter = {
            command = getExe pkgs.stylua;
            args = [ "-" ];
          };
          language-servers = [
            "lua-language-server"
            "typos"
            "scls"
            "harper"
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
            "scls"
            "harper"
          ];
        }
      ];
    };

    settings = {
      editor = {
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
        # better window navigation
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";

        # lazygit
        C-g = [
          ":write-all"
          ":insert-output lazygit >/dev/tty"
          ":redraw"
          ":reload-all"
        ];
      };
    };
  };
}
