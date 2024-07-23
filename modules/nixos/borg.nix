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
