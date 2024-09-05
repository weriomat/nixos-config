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
      enable = lib.mkForce false;
      package = pkgs.pulseaudioFull;
    };
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
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
    # TODO: here
    # services.udev.packages = with pkgs; [
    #   headsetcontrol
    # ];

    # environment.systemPackages = with pkgs; [
    #   headsetcontrol
    #   headset-charge-indicator
    #   pulsemixer
    # ];
  };
  # TODO: take a look at noisetorch
  # TODO: pulsemixer
}
