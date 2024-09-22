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

    borgbackup.jobs."hetzner" = {
      doInit = lib.mkForce false;
    };
  };

  networking.hostId = "fb363d05";

  # NOTE: kanshi is configured at the host level
  home-manager.users.${globals.username} = {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      profiles = {
        undocked = {
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
        home_office = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1200@60";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
              mode = "1920x1080@120";
              position = "1920,0";
              scale = 1.0;
            }
          ];
        };
      };
    };
  };
}
