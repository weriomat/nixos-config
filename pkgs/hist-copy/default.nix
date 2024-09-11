{pkgs, ...}: {
  hist-copy = pkgs.writeShellApplication {
    name = "hist-copy";
    text = ''
      #!/usr/bin/env bash
      cliphist list | wofi --dmenu | cliphist decode | wl-copy
    '';
  };
}
