# to get helix runnin in sudo symlink it to root folder -> sudo -i -> cd .config -> ln -s ../../home/marts/.config/helix/ /root/.config/helix
{pkgs, ...}: {
  home.packages = with pkgs; [
    helix
    cmake-language-server # cmake
    marksman # markdown
    lua-language-server # lua
    texlab # LaTeX
    taplo # toml
    delve # go debugger
    gopls # go lsp
    nodePackages.bash-language-server # bash
    nil # nix
    nixd # nix
    yaml-language-server # yaml
    nodePackages_latest.pyright # python
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

        # TODO: here
        texlab = {
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
        };
        nixd.command = "${pkgs.nixd}/bin/nixd";
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
          name = "python";
          language-servers = ["ruff" "pyright"];
          auto-format = true;
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
        auto-save = true;
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
        space.w = ":w";
        space.q = ":q";
        "{" = "goto_prev_paragraph";
        "}" = "goto_next_paragraph";
      };
    };
  };
}
