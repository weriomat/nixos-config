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
# services.udev.packages = with pkgs; [
#   headsetcontrol
# ];
# environment.systemPackages = with pkgs; [
#   headsetcontrol
#   headset-charge-indicator
#   pulsemixer
# ];
# TODO: take a look at noisetorch
# TODO: pulsemixer
# TODO: here
# hardware = {
#       logitech.wireless.enable = true;
#       logitech.wireless.enableGraphical = true; # Solaar.
#     };
#     environment.systemPackages = with pkgs; [
#       solaar
#     ];
#     services.udev.packages = with pkgs; [
#       logitech-udev-rules
#       solaar
#     ];
# logitech.wireless = { # Extra Logitech Support
#   enable = true;
#   enableGraphical = true;
# };
