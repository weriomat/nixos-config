{
  config,
  globals,
  ...
}: let
  host = "desktop";
in {
  services.borgbackup.jobs."hetzner" = {
    paths = [
      "/var/lib"
      "/srv"
      "/home"
    ];

    exclude = [
      # very large paths
      "/var/lib/docker"
      "/var/lib/systemd"
      "/var/lib/libvirt"

      # "/nix"
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
    ];

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
  };
}
