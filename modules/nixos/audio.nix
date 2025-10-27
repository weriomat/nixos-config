{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.audio.enable = mkEnableOption "Enable audio settings";

  config = mkIf config.audio.enable {
    security.rtkit.enable = true; # RealtimeKit system service, realtime scheduling priory to user process on demand -> used by Pulse audio

    services = {
      pipewire = {
        # TODO: noisetorch -> noise reduction for pipewire
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;
      };

      blueman.enable = true;
      pulseaudio.enable = false;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false; # manual enable
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
}
