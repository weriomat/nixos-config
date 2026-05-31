{ pkgs, ... }:
{
  programs.direnv = {
    package = (
      pkgs.unstable.direnv.overrideAttrs (_: {
        doCheck = false;
      })
    );
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
