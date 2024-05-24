{config, ...}: let
  host = "nix-desktop";
  repo = "ssh://u406968@u406968.your-storagebox.de:23/home/backups/${host}";
  environment.BORG_RSH = "ssh -i ~/.ssh/deploy_hetzner";

  encryption = {
    mode = "repokey-blake2";
    passCommand = "cat ${config.sops.secrets.borg-key.path}";
  };

  persistentTimer = true;
  inhibitsSleep = true;

  extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
  compression = "lz4";
  startAt = "daily";
in {
  # dn -> desktop nix
  services.borgbackup.jobs = {
    "hetzner/var/lib" = {
      inherit repo environment encryption persistentTimer inhibitsSleep extraCreateArgs compression startAt;

      archiveBaseName = "${config.networking.hostName}-varlib";
      paths = [
        "/var/lib"
        # "/srv"
      ];

      exclude = [
        # very large paths
        "/var/lib/docker"
        "/var/lib/systemd"
        "/var/lib/libvirt"
      ];
    };
    "hetzner/home/Backup_1TB_SSD" = {
      inherit repo environment encryption persistentTimer inhibitsSleep extraCreateArgs compression startAt;

      archiveBaseName = "${config.networking.hostName}-Backup_1TB_SSD";
      paths = [
        "/home/marts/Backup_1TB_SSD"
      ];
      exclude = [];
    };
    "hetzner/home" = {
      inherit repo environment encryption persistentTimer inhibitsSleep extraCreateArgs compression startAt;

      archiveBaseName = "${config.networking.hostName}-home";
      paths = [
        "/home"
      ];
      exclude = [
        "/home/*/.cache"

        # temporary files created by cargo and `go build`
        "**/target"
        "/home/*/go/bin"
        "/home/*/go/pkg"

        # backups not nessessary
        "/home/marts/Backup_3TB"
        "/home/marts/Backup"
        "/home/marts/Backup_1TB"
        "/home/marts/Backup_local"
        "/home/marts/Serien_Teil8"
        "/home/marts/Backup_1TB_SSD"
      ];
    };
    # "hetzner" = {
    #   inherit repo environment encryption persistentTimer inhibitsSleep extraCreateArgs compression startAt;

    #   archiveBaseName = "${config.networking.hostName}-homeObisidian";
    #   paths = [
    #     "/home/marts/Obsidian"
    #   ];
    #   exclude = [
    #   ];
    # };
  };
}
