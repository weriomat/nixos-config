{globals, ...}: {
  programs.steam = {
    enable =
      if globals.isWork
      then false
      else true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
}
