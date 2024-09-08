{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # pretty
      pkief.material-product-icons
      pkief.material-icon-theme
      zhuangtongfa.material-theme
      esbenp.prettier-vscode
      gruntfuggly.todo-tree
      oderwat.indent-rainbow
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      xaver.clang-format
      vscodevim.vim
      tamasfe.even-better-toml
      # tabnine.tabnine-vscode
      svelte.svelte-vscode
      rust-lang.rust-analyzer
      roman.ayu-next
      ms-python.python
      wholroyd.jinja
      ms-pyright.pyright

      # latex
      james-yu.latex-workshop
      valentjn.vscode-ltex
    ];
  };
}
