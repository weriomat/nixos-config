{ pkgs, ... }:
{
  home.packages = [ pkgs.supersonic ];

  xdg.configFile."supersonic/themes/" = {
    source = pkgs.catppuccin-supersonic;
    recursive = true;
  };
}
