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
      # NOTE: maybe configure `XF86MonBrightness<Up|Down>` as well if need be for controlling backlight of a keyboard
      bind = [
        ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2"
        ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ",XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
      ];

      # TODO: maybe this in per host config as well?
      # bindle = [
      #   # volume
      #   ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      #   ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      #   # backlight
      #   ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      #   ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      # ];
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
