{
  lib,
  ...
}:
{
  # NOTE: disable virtualization
  virt.enable = lib.mkForce false;
  networking = {
    iwd.enable = true;
    networkd = {
      wlan.mac = "b8:1e:a4:46:37:3d";
      lan.mac = "74:5d:22:c4:4e:75";
    };
  };

  # TODO: for every host a vpn as a split tunnel for email relay or sth: https://ssh.sshslowdns.com/wireguard-split-tunnel-config/
  # TODO: setup email with host

  # TODO: smartd for other hosts
  # TODO: upstream
  # TODO: https://rair.dev/zfs-smart-ntfy/
  sops.secrets."ntfy" = { };

  services = {
    element-desktop.enable = true;

    # TODO: setup mail as a relay though vps
    msmartd.enable = true;

    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
      # TODO: here -> probably needs a patch
      # TODO: upstream a patch?
      # zed.settings = {
      #   ZED_NTFY_TOPIC = "zfs";
      #   ZED_NTFY_URL = "https://ntfy.weriomat.com";
      #   ZED_NTFY_ACCESS_TOKEN = "$(cat ${config.sops.secrets."ntfy".path})";
      # };
    };

    # set cache size for laglanguagetool to 8gb
    languagetool.settings.cacheSize = lib.mkForce 8192;

    # i think hardened kernel bug
    logrotate.checkConfig = false;
  };

  networking.hostId = "fb363d05";
}
