{
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
  # TODO: sync with HM and enable again
  options.myfont.enable = mkEnableOption "Enable my fontconfiguration" // {
    default = false;
  };
  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = mkForce false;
      packages = [
        # pkgs.source-sans
        # pkgs.apple-emoji
        pkgs.fira-go

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
          # TODO: set default fonts
          sansSerif = [ "DejaVu Sans" ];
          # ["FiraGO"];
          serif = [ "DejaVu Serif" ];
          # ["Source Serif"];
          monospace = [
            # "DejaVu Sans Mono"
            "MonoLisa Nerd Font"
          ];
          emoji = [ "apple-emoji" ];
        };
      };
    };
  };
}
