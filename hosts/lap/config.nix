{
  globals,
  lib,
  ...
}: {
  # NOTE: disbale virtualiziation
  virt.enable = lib.mkForce false;

  # TODO: for every host a vpn as a split tunnel for email relay or sth: https://ssh.sshslowdns.com/wireguard-split-tunnel-config/
  # TODO: setup email with host

  # TODO: smartd for other hosts
  # TODO: upstream
  # TODO: https://rair.dev/zfs-smart-ntfy/
  sops.secrets."ntfy" = {};

  services = {
    # TODO: setup mail as a relay though vps
    msmartd.enable = true;

    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
      # TODO: here -> probably needs a patch
      # TODO: upsteam a patch?
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

  # NOTE: kanshi is configured at the host level
  home-manager.users.${globals.username} = {
    services.kanshi = {
      enable = false;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                mode = "1920x1200@60";
                position = "0,0";
                scale = 1.0;
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                # internal display
                criteria = "eDP-1";
                status = "enable";
                mode = "1920x1200@60";
                scale = 1.0;
              }
              {
                criteria = "Lenovo Group Limited Y25-30 U3W0DYXB";
                status = "enable";
                mode = "1920x1080@240";
                scale = 1.0;
              }
              {
                criteria = "Acer Technologies VG270U P 0x1071B314";
                status = "enable";
                mode = "1920x1080@120"; # TODO: check if 1440p works
                scale = 1.0;
              }
            ];
          };
        }
      ];
    };
  };
}
