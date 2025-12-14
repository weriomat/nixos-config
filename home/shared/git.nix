{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkIf
    mkOption
    types
    mkEnableOption
    ;
  cfg = config.my_git;


in
{
  options.my_git = {
    username = mkOption {
      type = types.str;
      default = "weriomat";
    };
    email = mkOption {
      type = types.str;
      default = "engel@weriomat.com";
    };
    key = mkOption {
      type = types.str;
      default = "E64AE4E613602685";
    };
    ssh-selfhosted.enable = mkEnableOption "Ssh configuration for selfhosted stuff" // {
      default = true;
    };
  };
  config = mkMerge [
    {
      home.packages = [
        pkgs.yubikey-manager
        pkgs.yubikey-personalization
        pkgs.paperkey
        pkgs.meld
      ];

      catppuccin.delta.enable = true;

      programs = {
        gpg = {
          enable = true;
          homedir = "${config.xdg.dataHome}/gnupg";
          scdaemonSettings = {
            reader-port = "Yubico Yubi";
            disable-ccid = "";
          };
        };

        git = {
          enable = true;

          userName = cfg.username;
          userEmail = cfg.email;

          lfs.enable = true;

          extraConfig = {
            safe.directory = "*";
            merge.tool = "meld";
            init.defaultBranch = "main";
            tag.gpgSign = true;
            # NOTE: do not rebase by default
            pull.rebase = false;
            format.signOff = true;
            rerere.enabled = true;
            rebase = {
              autoSquash = true;
              autoStash = true;
              updateRefs = true;
            };
            url = {
              "ssh://git@git.weriomat.com".insteadOf = "f:";
              "ssh://git@github.com:".insteadOf = "gh:";
            };

            merge.conflictStyle = "zdiff3";
          };

          delta = {
            enable = true;
            options = {
              line-numbers = true;
              hyprlinks = true;
              true-color = "always";
            };
          };

          ignores = [
            "result/"
            "result"
            ".direnv"
            ".direnv/"
            "target"
            "target/"
          ];

          signing = {
            inherit (cfg) key;
            signByDefault = true;
            format = "openpgp";
          };
        };
      };
    }

    {
      programs.ssh = {
        enable = true;
        compression = true;
        controlMaster = "auto";
        controlPersist = "10m";
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        extraOptionOverrides.IdentityFile = "${config.home.homeDirectory}/.ssh/id_rsa_yubikey.pub";

        extraConfig = "IdentitiesOnly yes";

        matchBlocks = mkMerge [
          { "github.com".user = "git"; }
          (mkIf cfg.ssh-selfhosted.enable {
            # git services
            "git.tu-berlin.de".user = "git";
            "gitlab.cobalt.rocks".user = "git";
            "git.weriomat.com" = {
              user = "git";
              port = 2077;
            };

            # selfhosted
            storage = {
              user = "u406968";
              hostname = "u406968.your-storagebox.de";
              port = 23;
              identityFile = "${config.home.homeDirectory}/.ssh/deploy_hetzner";
            };
            vps = {
              user = "weriomat";
              hostname = "49.13.52.45";
              port = 2077;
            };
            nrw = {
              user = "weriomat";
              hostname = "192.168.178.105";
              port = 2077;
            };
            by = {
              user = "weriomat";
              hostname = "192.168.178.114";
              port = 2077;
            };
            ber = {
              user = "weriomat";
              hostname = "192.168.178.128";
              port = 2077;
            };
            bb = {
              user = "weriomat";
              hostname = "192.168.178.110";
              port = 2077;
            };
            bw = {
              user = "weriomat";
              hostname = "192.168.178.106";
              port = 2077;
            };
            sl = {
              user = "weriomat";
              hostname = "192.168.178.124";
              port = 2077;
            };
            sn = {
              user = "weriomat";
              hostname = "192.168.178.127";
              port = 2077;
            };
            mv = {
              user = "weriomat";
              hostname = "192.168.178.129";
              port = 2077;
            };
            th = {
              user = "weriomat";
              hostname = "192.168.178.136";
              port = 2077;
            };
            big = {
              user = "weriomat";
              hostname = "10.100.0.5";
              port = 2077;
            };
            big-local = {
              user = "weriomat";
              hostname = "192.168.178.79";
              port = 2077;
            };
          })
        ];
      };
    }

    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableScDaemon = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-gtk2;
      };
    })
  ];
}
