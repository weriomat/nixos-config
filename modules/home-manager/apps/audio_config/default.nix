{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.audio_config.enable = mkEnableOption "Enable HomeManager audio setup";

  config = mkIf config.audio_config.enable {
    home.packages = with pkgs; [
      playerctl
      pamixer
      # TODO: factor out from waybar
      sway-audio-idle-inhibit # no inhbit if audio playing
    ];
    # TODO: audio
    # services.pulseeffects = {};
    # services.playerctld = {};
    # services.pasystray = {};
    # services.easyeffects = {};
    wayland.windowManager.hyprland.settings = {
      # TODO: maybe this in per host config as well?
      # bindle = [
      #   # volume
      #   ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      #   ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      #   # backlight
      #   ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      #   ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      # ];
      bind = [
        # TODO: move those to
        # media and volume control
        ",XF86AudioRaiseVolume, exec, pamixer -i 2"
        ",XF86AudioLowerVolume, exec, pamixer -d 2"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"

        # TODO: here
        # bind=,XF86AudioMicMute,exec, volume --toggle-mic
        # bind=ALT,XF86AudioPlay,exec,systemctl --user restart playerctld
        # bind=,XF86MonBrightnessUp,exec, brightness --inc
        # bind=,XF86MonBrightnessDown,exec, brightness --dec
        # ",XF86AudioMicMute" = "exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
      ];
      # TODO: here
      # bindi = {
      #   ",XF86MonBrightnessUp" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl +5%";
      #   ",XF86MonBrightnessDown" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl -5% ";
      #   ",XF86AudioRaiseVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -i 5";
      #   ",XF86AudioLowerVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -d 5";
      #   ",XF86AudioMute" = "exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute";
      #   ",XF86AudioMicMute" = "exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
      #   ",XF86AudioNext" = "exec,playerctl next";
      #   ",XF86AudioPrev" = "exec,playerctl previous";
      #   ",XF86AudioPlay" = "exec,playerctl play-pause";
      #   ",XF86AudioStop" = "exec,playerctl stop";
      # };
      #   windowrule = float,audacious
      #   windowrule = workspace 8 silent, audacious
      #   windowrule = float,title:^(Volume Control)$
      #   windowrule = size 700 450,title:^(Volume Control)$
      #   windowrule = move 40 55%,title:^(Volume Control)$
      #   windowrulev2 = float,class:^(pavucontrol)$
      #   windowrulev2 = float,class:^(SoundWireServer)$
    };
  };
}
