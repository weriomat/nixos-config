{
  pkgs,
  globals,
  lib,
  ...
}: {
  config =
    if globals.isWork
    then {}
    else {
      networking.hosts = {"192.168.178.199" = ["nas"];};
      # fileSystems."/home/marts/nfs" = {
      #   device = "nas:/mnt/zpool5";
      #   fsType = "nfs";
      #   options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
      # };

      # fileSystems."/home/marts/share" = {
      #   device = "nas:/mnt/zpool5/share";
      #   fsType = "nfs";
      #   options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
      # };

      environment.systemPackages = with pkgs; [
        nfs-utils
      ];
    };
}
