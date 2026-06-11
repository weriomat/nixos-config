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
    getExe
    getExe'
    optionalString
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

    wayland.windowManager.hyprland.extraConfig = /* lua */ ''
      -- audio
      hl.on("hyprland.start", function()
      	hl.exec_cmd("${getExe pkgs.sway-audio-idle-inhibit} &")
      end)

      -- audio (repeating)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --output-volume raise"), { repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --output-volume lower"), { repeating = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --playerctl next"), { repeating = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --playerctl previous"), { repeating = true })
      ${optionalString globals.laptop "hl.bind(\"XF86MonBrightnessUp\", hl.dsp.exec_cmd(\"${getExe' config.services.swayosd.package "swayosd-client"}  --brightness raise\"), { repeating = true })"}
      ${optionalString globals.laptop "hl.bind(\"XF86MonBrightnessDown\", hl.dsp.exec_cmd(\"${getExe' config.services.swayosd.package "swayosd-client"} --brightness lower\"), { repeating = true })"}

      -- audio (non-repeating)
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --output-volume mute-toggle"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --input-volume mute-toggle"))
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --playerctl play-pause"))
      hl.bind("XF86AudioStop", hl.dsp.exec_cmd("${getExe' config.services.swayosd.package "swayosd-client"} --playerctl stop"))
    '';


  };
}
