{ config, pkgs, inputs, outputs, ... }: {

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      palette = "catppuccin_mocha";
    } // builtins.fromTOML
      (builtins.readFile "${pkgs.starship-catppuccin}/themes/theme.toml");
  };
  # "${pkgs.packages.starship-catppuccin}/themes/theme.toml");
  # pkgs.additions.callPackage ./starship-catppuccin { }
  # "${pkgs.callPackagestarship-catppuccin.override { flavor = "mocca"; }}");
}
