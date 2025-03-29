{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.screenshot;
in
{
  options.screenshot.enable = mkEnableOption "screenshot setup";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = [
      # screenshot
      ",Print, exec, ${
        getExe inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      } --notify copysave area ~/Pictures/Screenshots/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
      # edit screenshot
      ''$mainMod, M, exec, ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe pkgs.swappy} -f -''
    ];

    xdg.configFile."swappy/config".text = ''
      [Default]
      save_dir=${config.xdg.userDirs.pictures}/Screenshot_edits
      save_filename_format=swappy-%Y%m%d-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
      paint_mode=brush
      early_exit=false
      fill_shape=false
    '';
  };
}
