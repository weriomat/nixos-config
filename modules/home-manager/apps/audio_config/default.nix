{
  config,
  globals,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    getExe
    getExe'
    ;
in
{
  options.audio_config.enable = mkEnableOption "HomeManager audio setup";

  # NOTE: this configures brightness stuff as well
  config = mkIf config.audio_config.enable {
    home.packages = [
      pkgs.pasystray # pulseaudio systray
      pkgs.pavucontrol # pulseaudio volume control
      pkgs.playerctl # music player controller
      pkgs.pulsemixer # pulseaudio mixer
      pkgs.pamixer
    ];

    # TODO: audio
    # services.pulseeffects = {};
    # services.playerctld = {};
    # services.pasystray = {};
    # services.easyeffects = {};

    services.swayosd.enable = true;

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "${getExe pkgs.sway-audio-idle-inhibit} &"
      ];

      # TODO: more keys to assign: "XF86Display", "XF86Favorites", "XF86WLAN" (assigned)
      # NOTE: the [e] means repeating
      binde = mkMerge [
        [
          ",XF86AudioRaiseVolume, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --output-volume raise"
          ",XF86AudioLowerVolume, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --output-volume lower"
          ",XF86AudioNext, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --playerctl next"
          ",XF86AudioPrev, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --playerctl previous"
        ]
        (mkIf globals.laptop [
          ",XF86MonBrightnessUp, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --brightness raise"
          ",XF86MonBrightnessDown, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --brightness lower"
        ])
      ];

      bind = [
        ",XF86AudioMute, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --input-volume mute-toggle"
        ",XF86AudioPlay, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --playerctl play-pause"
        ",XF86AudioStop, exec, ${getExe' config.services.swayosd.package "swayosd-client"} --playerctl stop"
      ];

      # TODO: maybe this in per host config as well? `hyprctl clients`
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
