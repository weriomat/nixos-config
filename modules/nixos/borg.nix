{
  globals,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [vorta];
  services.borgbackup.jobs = {
    "hetzner" = {
      repo = "ssh://u406968@u406968.your-storagebox.de:23/home/backups/${globals.host}";
      environment.BORG_RSH = "ssh -i /home/marts/.ssh/deploy_hetzner";

      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets.borg-key.path}";
      };

      persistentTimer = true;
      inhibitsSleep = true;

      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      compression = "lz4";
      startAt = "daily";
      archiveBaseName = "${config.networking.hostName}-hetzner";
      paths = [
        "/var/lib"
        "/home/${globals.username}"
      ];

      doInit = false;

      exclude = [
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
  };
}
