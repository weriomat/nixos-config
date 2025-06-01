{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    terraform.enable = true;
    yamlfmt = {
      enable = true;
      excludes = [ "secrets/*" ];
    };
    jsonfmt.enable = true;
    deadnix.enable = true;
    actionlint.enable = true;
    statix.enable = true;
    nixfmt.enable = true;
    # TODO: markdownlint -> markdownformat?
    shellcheck.enable = pkgs.hostPlatform.system != "riscv64-linux";
    shfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
    typos = {
      # TODO: dont format in place
      # enable = true;
      threads = 4;
      hidden = true;
      excludes = [ "secret/**" ];
    };
  };
}
