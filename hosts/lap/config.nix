{lib, ...}: {
  services = {
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    # i think hardened kernel bug
    logrotate.checkConfig = false;
    borgbackup.jobs."hetzner" = {
      doInit = lib.mkForce true;
      exclude = [];
    };
  };
  networking.hostId = "fb363d05";
}
