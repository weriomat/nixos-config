{
  config,
  ...
}:
{
  # idea from https://github.com/different-name/nix-files/blob/master/dyad/nixos/programs/nh.nix
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.nixos/nixos";
  };
}
