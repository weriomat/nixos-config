{
  pkgs,
  lib,
  config,
  ...
}: {
  options.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable audio settings";
    };
  };
  config = lib.mkIf config.audio.enable {
    sound.enable = true;
    hardware.pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
}
