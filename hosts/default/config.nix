{
  lib,
  globals,
  ...
}:
{
  steam.enable = true;

  services.borgbackup.jobs."hetzner" = {
    exclude = lib.mkForce [
      "/home/marts/Backup_1TB_SSD/not_borg"
      "/home/marts/Backup_1TB_SSD/lost+found"
      "/home/marts/test/tee"
      "/home/marts/test/Schule/.journal"
      "/home/marts/test/Schule/.journal_info_block"
      "/home/marts/test/Schule/.Spotlight-V100"
      "/home/marts/test/Schule/.fseventsd"
      "/home/marts/test/Schule/Fotos/Photos Library.photoslibrary/resources/cpl/cloudsync.noindex/storage/filecache/AXh/cplAXhr_wL8uqqiPzVHlUDMvaB3GcXm.mov"
      "/home/marts/test/Schule/Fotos/Photos Library.photoslibrary/resources/cpl/cloudsync.noindex/storage/filecache/ATB/cplATBdFwsuv9kYYvyV2bOoxGrL0rzd.mov"
      "/home/marts/test/Schule/Fotos/Photos Library.photoslibrary/originals/9/914B0D20-1054-43F4-9DD2-3EF3690BB1C1.mov"
      "/home/marts/test/Schule/Fotos/Photos Library.photoslibrary/originals/B/BEFF09F8-B04C-4CC3-9214-E84E835007F4.mov"
      "/home/marts/test/Schule/.TemporaryItems"
      "/home/marts/Schule/Schule/.TemporaryItems"
      "/home/marts/Schule/Schule/Fotos/Photos Library.photoslibrary/originals/B/BEFF09F8-B04C-4CC3-9214-E84E835007F4.mov"
      "/home/marts/Schule/Schule/Fotos/Photos Library.photoslibrary/originals/9/914B0D20-1054-43F4-9DD2-3EF3690BB1C1.mov"
      "/home/marts/Schule/Schule/Fotos/Photos Library.photoslibrary/resources/cpl/cloudsync.noindex/storage/filecache/ATB/cplATBdFwsuv9kYYvyV2bOoxGrL0rzd.mov"
      "/home/marts/Schule/Schule/Fotos/Photos Library.photoslibrary/resources/cpl/cloudsync.noindex/storage/filecache/AXh/cplAXhr_wL8uqqiPzVHlUDMvaB3GcXm.mov"
      "/home/marts/Schule/Schule/.fseventsd"
      "/home/marts/Schule/Schule/.Spotlight-V100"
      "/home/marts/Schule/Schule/.journal_info_block"
      "/home/marts/Schule/Schule/.journal"
      "/home/marts/test/BACKUP_1"
      "/home/marts/Backup_3TB"
      "/home/marts/Backup"
      "/home/marts/Backup_1TB"
      "/home/marts/Backup_local"
      "/home/marts/Serien_Teil8"
      "/var/lib/systemd/pstore"
      "/var/lib/machines"
      "/var/lib/portables"
      "/var/lib/NetworkManager-fortisslvpn"
      "/var/lib/libvirt"
      "/var/lib/private"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/cups"
      "/var/lib/lightdm"
      "/var/lib/systemd/random-seed"
      "/var/lib/logrotate.status"
      "/var/lib/AccountsService/users"
      "/var/lib/containers/storage/tmp"
      "/var/lib/swtpm-localca"

      "/home/*/.cache"
      "**/target"
      "/home/*/go/bin"
      "/home/*/go/pkg"
    ];
  };

  # NOTE: kanshi is configured at the host level
  home-manager.users.${globals.username} = {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      profiles = {
        normal = {
          outputs = [
            {
              criteria = "DP-1";
              status = "enable";
              mode = "2560x1440@144";
              position = "1920,0";
              scale = 1.0;
            }
            {
              criteria = "DP-3";
              status = "enable";
              mode = "1920x1080@240";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
              mode = "1920x1080@60";
              position = "4480,0";
              scale = 1.0;
            }
          ];
        };
      };
    };
  };
}
