{ pkgs, ... }:
{
  programs.direnv = {
    package = pkgs.unstable.direnv;
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
