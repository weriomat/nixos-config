_: {
  # TODO: https://github.com/phiresky/ripgrep-all

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--no-ignore"
      "--max-columns-preview"
      "--colors=line:style:bold"
    ];
  };
}
