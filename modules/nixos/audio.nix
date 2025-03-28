{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
  options.audio.enable = mkEnableOption "Enable audio settings";

  config = mkIf config.audio.enable {
    security.rtkit.enable = true; # RealtimeKit system service, realtime scheduling priory to user process on demand -> used by Pulse audio

    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;
      };

      blueman.enable = true;
    };

    hardware = {
      pulseaudio.enable = false;

      # TODO: take a look at pkgs.overskride instead of blueman-applet, no applet tho
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };
}
# pipewire
# TODO: https://github.com/Goxore/nixconf/blob/main/homeManagerModules/features/pipewire.nix
# TODO: here
# services.udev.packages = [
#   pkgs.headsetcontrol
# ];
# environment.systemPackages = [
#   pkgs.headsetcontrol
#   pkgs.headset-charge-indicator
#   pkgs.pulsemixer
# ];
# TODO: take a look at noisetorch
# TODO: pulsemixer
