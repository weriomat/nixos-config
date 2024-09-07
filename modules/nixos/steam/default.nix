{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.steam.enable = mkEnableOption "Enable Gaming thingies";

  # This is going to be decided per host
  config = mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
    environment.systemPackages = with pkgs; [lunar-client];
  };
}
