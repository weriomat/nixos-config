_: {
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--no-ignore"
      "--max-columns-preview"
      "--colors=line:style:bold"
    ];
  };
}
