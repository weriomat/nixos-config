{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (inputs.hypr-contrib.packages.${pkgs.stdenv.hostPlatform.system})
    grimblast
    ;
  cfg = config.screenshot;
in
{
  options.screenshot.enable = mkEnableOption "screenshot setup";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraConfig = /* lua */ ''
      -- screenshots
      hl.bind("Print", hl.dsp.exec_cmd("${getExe grimblast} --notify copysave area ~/Pictures/Screenshots/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"))
      hl.bind("XF86Display", hl.dsp.exec_cmd("${getExe pkgs.wl-ocr}"))
      hl.bind(mod .. " + XF86Display", hl.dsp.exec_cmd("${getExe pkgs.wl-screenrec} -g \"$(${getExe pkgs.slurp})\" -f ~/Pictures/Screenrecs/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').mp4"))
      hl.bind(mod .. " + Print", hl.dsp.exec_cmd("${getExe pkgs.grim} -g \"$(${getExe pkgs.slurp})\" - | ${getExe pkgs.swappy} -f -"))
      hl.window_rule({
        match = { class = "swappy" },
        opaque = true,
        center = true,
        stay_focused = true,
      })
    '';

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
