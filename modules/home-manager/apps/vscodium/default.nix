{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.vscode.enable = mkEnableOption "Enable my vscode config";

  config = mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = [
        # pretty
        pkgs.vscode-extensions.pkief.material-product-icons
        pkgs.vscode-extensions.pkief.material-icon-theme
        pkgs.vscode-extensions.zhuangtongfa.material-theme
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.gruntfuggly.todo-tree
        pkgs.vscode-extensions.oderwat.indent-rainbow
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons

        pkgs.vscode-extensions.xaver.clang-format
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.tamasfe.even-better-toml
        # tabnine.tabnine-vscode
        pkgs.vscode-extensions.svelte.svelte-vscode
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.roman.ayu-next
        pkgs.vscode-extensions.ms-python.python
        pkgs.vscode-extensions.wholroyd.jinja
        pkgs.vscode-extensions.ms-pyright.pyright

        # latex
        pkgs.vscode-extensions.james-yu.latex-workshop
        pkgs.vscode-extensions.valentjn.vscode-ltex
      ];
    };
  };
}
