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
    ;
  toggle-mic = pkgs.writeShellApplication {
    name = "toggle-mic";
    runtimeInputs = with pkgs; [
      pamixer
      libnotify
      gnugrep
      gawk
      coreutils
    ];

    text = ''
      #!/usr/bin/env bash
      if ! command -v pamixer > /dev/null; then
          exit_code="$?"

          if [ "$notify" ]; then
              notify-send \
                  --hint=int:transient:1 \
                  "Error" \
                  "'pamixer' is not available."
          fi

          exit $exit_code
      fi

      pamixer --list-sources \
          | grep input \
          | awk '{print $1}' \
          | while read -r index; do
          mic_muted="$(pamixer --source "$index" --get-mute)"

          if [ "$mic_muted" = "true" ]; then
              pamixer --source "$index" -u
          else
              pamixer --source "$index" -m
          fi

          word=$(pamixer --list-sources | grep input | grep "$index" | awk '{print $4}')
          line=$(pamixer --list-sources | grep input | grep "$index" | grep -o "''${word}[^\"]*" | grep -o "[^\"]*")
          notify-send --hint=int:transient:1 "$line" "Toggled"
      done
    '';
  };
in
{
  options.audio_config.enable = mkEnableOption "Enable HomeManager audio setup";

  # NOTE: this configures brightness stuff as well
  config = mkIf config.audio_config.enable {
    home.packages = with pkgs; [
      pasystray # pulseaudio systray
      pavucontrol # pulseaudio volume control
      playerctl # music player controller
      pulsemixer # pulseaudio mixer
      pamixer
    ];

    # TODO: audio
    # services.pulseeffects = {};
    # services.playerctld = {};
    # services.pasystray = {};
    # services.easyeffects = {};

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "${getExe pkgs.sway-audio-idle-inhibit} &"
      ];

      # NOTE: the [e] means repeating
      binde = mkMerge [
        [
          ",XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} -i 2"
          ",XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} -d 2"
          ",XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
          ",XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"
        ]
        (mkIf globals.laptop [
          ",XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set +5%"
          ",XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set -5% "

        ])
      ];

      bind = [
        ",XF86AudioMute, exec, ${getExe pkgs.pamixer} -t"
        ",XF86AudioMicMute, exec, ${getExe toggle-mic}"
        ",XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
        ",XF86AudioStop, exec, ${getExe pkgs.playerctl} stop"
      ];

      # TODO: maybe this in per host config as well?
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
