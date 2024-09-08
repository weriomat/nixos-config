{
  lib,
  globals,
  ...
}: {
  # NOTE: disbale virtualiziation
  virt.enable = lib.mkForce false;

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
