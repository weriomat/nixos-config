{ pkgs, ... }: {
  # TODO: fix this
  imports = [ (import ./theme-template.nix) ];
  home.packages = with pkgs; [
    vesktop
    (discord.override { withVencord = true; })
  ];
}
