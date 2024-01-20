{ ... }: {

  # Enable manpages
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
    doc.enable = true;
    nixos.enable = true;
    info.enable = true;
  };
  # services.hoogle.enable = true;
}
