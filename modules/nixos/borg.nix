{
  globals,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.sops) templates;
  placeholders = config.sops.placeholder;
in
{
  options.borg.enable = mkEnableOption "Enable borg settings";
  config = mkIf config.borg.enable {
    environment.systemPackages = [ pkgs.vorta ]; # graphical borg frontend

    # NOTE: idea from: https://gitlab.cobalt.rocks/shared-configs/nixos-ng/-/blob/b41b04b8d1dbcfe536c4fa175cb13f80fb484e1d/hosts/carbon/backups/shared.nix#L5
    # borgmatic shared configuration to provide repositories for per-application backups
    sops = {
      secrets = {
        # NOTE: this user should only have ro access to the encrypted backup
        # username for ssh to storage box
        "storage_box/user" = { };
        # port for ssh to storage box
        "storage_box/port" = { };
        # hostname of storage box
        "storage_box/host" = { };
        # ssh private key to access storage box
        "storage_box/key" = { };
        # public ssh host key of storage box
        "storage_box/host_key" = { };
        # encryption key for borg repo
        "storage_box/encryption_passphrase" = { };
        # ntfy user password
        "storage_box/ntfy" = { };
      };

      templates = {
        borgmaticCredentials.content = ''
          storagePort=${placeholders."storage_box/port"}
          storageUser=${placeholders."storage_box/user"}
          storageHost=${placeholders."storage_box/host"}
          ntfy=${placeholders."storage_box/ntfy"}
        '';
        backupKey.content = ''
          ${placeholders."storage_box/key"}
        '';
      };
    };

    services.borgmatic = {
      enable = true;
      enableConfigCheck = false; # NOTE: disabled due to sops

      settings = {
        ntfy = {
          topic = "backup";
          server = "https://ntfy.weriomat.com";
          username = "laptop";
          password = "\${ntfy}";

          start = {
            title = "A borgmatic backup started - laptop";
            message = "Watch this space...";
            tags = "borgmatic,lap";
            priority = "min";
          };
          finish = {
            title = "A borgmatic backup completed successfully - laptop";
            message = "Nice!";
            tags = "borgmatic,lap,+1";
            priority = "min";
          };
          fail = {
            title = "A borgmatic backup failed - laptop";
            message = "You should probably fix it";
            tags = "borgmatic,lap,-1,skull";
            priority = "max";
          };
          states = [
            "start"
            "finish"
            "fail"
          ];
        };

        source_directories = [
          "/var/lib"
          "/var/log"
          "/etc"
          "/home/${globals.username}"
        ];
        exclude_patterns = [
          "/home/*/.cache"
          "**/target"
          "/home/*/go/bin"
          "/home/*/go/pkg"
          "**/iso"
          "*.img"
          "*.iso" # dont backup iso images
          "/home/*/Pictures/icloud_bak" # dont backup foto backup
          "/home/*/P/nix/nixpkgs" # dont backup nixpkgs
          "**/node_modules" # node modules
          "**/dist" # electron stuff i think
          "/home/*/.arduino15" # dont need arudinio libs to be backed up
        ];

        # Name of the archive. Borg placeholders can be used. See the
        archive_name_format = "{hostname}-laptop-{now}";
        repositories = [
          {
            label = "storage-box";
            path = "ssh://\${storageUser}@\${storageHost}/./laptop";
          }
        ];
        # Passphrase to unlock the encryption key with.
        encryption_passcommand = "${pkgs.coreutils}/bin/cat ${
          config.sops.secrets."storage_box/encryption_passphrase".path
        }";
        # Number of seconds between each checkpoint during a long-running backup.
        checkpoint_interval = 1800;
        # Type of compression to use when creating archives.
        compression = "zlib,6";
        # Remote network upload rate limit in kiBytes/second.
        upload_rate_limit = 4000;
        # Command to use instead of "ssh". This can be used to specify ssh options.
        ssh_command = "ssh -p \${storagePort} -i ${templates.backupKey.path} -o UserKnownHostsFile=${
          config.sops.secrets."storage_box/host_key".path
        }";
        # Keep all archives within this time interval. See "skip_actions" for
        # disabling pruning altogether.
        # Number of daily archives to keep.
        keep_daily = 5;
        # Number of weekly archives to keep.
        keep_weekly = 4;
        # Number of monthly archives to keep.
        keep_monthly = 6;
        # Number of yearly archives to keep.
        keep_yearly = 1;
        checks = [
          {
            name = "repository";
            frequency = "1 month";
          }
          {
            name = "archives";
            frequency = "1 month";
          }
          {
            name = "data";
            frequency = "2 month";
          }
        ];
      };
    };
    systemd = {
      services.borgmatic = {
        serviceConfig = {
          EnvironmentFile = templates.borgmaticCredentials.path;
          User = "root";
          Group = "root";
        };

        path = [
          config.systemd.package # for stopping services
          pkgs.borgmatic # borgmatic itself, for good measure
        ];
      };
    };
  };
}
