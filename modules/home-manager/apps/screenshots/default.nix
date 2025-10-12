{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (inputs.hypr-contrib.packages.${pkgs.system})
    grimblast
    ;
  cfg = config.screenshot;
in
{
  options.screenshot.enable = mkEnableOption "screenshot setup";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        ",Print, exec, ${getExe grimblast} --notify copysave area ~/Pictures/Screenshots/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png" # screenshot
        ",XF86Display, exec, ${getExe pkgs.wl-ocr}" # copy text recognized to clipboard
        "$mainMod SHIFT, Print, exec, ${getExe pkgs.wl-ocr}"
        "$mainMod, XF86Display, exec, ${getExe pkgs.wl-screenrec} -g \"$(${getExe pkgs.slurp})\" -f ~/Pictures/Screenrecs/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').mp4" # screenrecorder
        "$mainMod, Print, exec, ${getExe pkgs.grim} -g \"$(${getExe pkgs.slurp})\" - | ${getExe pkgs.swappy} -f -" # edit screenshot
      ];
      windowrule = [
        "opaque, class:swappy"
        "center 1, class:swappy"
        "stayfocused, class:swappy"
      ];
    };

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
