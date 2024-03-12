{pkgs, ...}: {
  networking.hosts = {"192.168.178.199" = ["nas"];};
  # fileSystems."/mnt/zpool5" = {
  fileSystems."/home/marts/nfs" = {
    device = "nas:/mnt/zpool5";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
  };
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
}
