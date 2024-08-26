{lib, ...}: {
  # TODO: zfs mail
  services = {
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };

    # i think hardened kernel bug
    logrotate.checkConfig = false;

    borgbackup.jobs."hetzner" = {
      doInit = lib.mkForce false;
      # exclude = [];
    };
  };
  networking.hostId = "fb363d05";

  # TODO: kanashi
  # home-manager.users.${globals.username}.monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 1929;
  #     height = 1200;
  #     x = 0;
  #     workspace = "1";
  #     primary = true;
  #   }
  # ];
}
