{
  pkgs,
  lib,
  ...
}: {
  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    vpcs.enable = true;
    ubridge.enable = true;
  };

  systemd.services.gns3-server.serviceConfig.ProtectSystem = lib.mkForce false;

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    enableHardening = true;
    enableKvm = false;
    addNetworkInterface = true;
  };

  environment.systemPackages = [pkgs.gns3-gui pkgs.xterm];
}
