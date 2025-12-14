{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.myfont;
in
{
  options.myfont.enable = mkEnableOption "Enable my fontconfiguration" // {
    default = true;
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = mkForce false;
      packages = [
        inputs.monoLisa.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.apple-color-emoji
        pkgs.fira
        pkgs.fira-go
        pkgs.roboto-serif
        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.blex-mono
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
        pkgs.nerd-fonts.fira-mono
        pkgs.noto-fonts-color-emoji

        # default fonts, without emoji
        pkgs.dejavu_fonts
        pkgs.freefont_ttf
        pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
        pkgs.liberation_ttf
        pkgs.unifont
      ];

      fontDir.enable = true; # xwayland
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [
            "FiraGO"
            "Fira Sans"
            "Iosevka Nerd Font"
          ];
          serif = [
            "DejaVu Serif"
            "Roboto Serif"
          ];
          monospace = [
            "MonoLisa Nerd Font"
            "JetBrainsMonoNL Nerd Font"
            "BlexMono Nerd Font Mono"
          ];
          emoji = [
            "Apple Color Emoji"
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
