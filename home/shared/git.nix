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
    getExe
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

          settings = {
            user = {
              inherit (cfg) email;
              name = cfg.username;
            };

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

          lfs.enable = true;

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
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            line-numbers = true;
            hyprlinks = true;
            true-color = "always";
          };
        };
        lazygit.settings = {
          git.pagers = [
            {
              pager = "${getExe pkgs.delta} --paging=never --dark";
              colorArg = "always";
            }
          ];
          customCommands = [
            # from https://github.com/jesseduffield/lazygit/wiki/Custom-Commands-Compendium#pushing-to-a-specific-remote-repository
            {
              key = "<c-P>";
              description = "Push to a specific remote repository";
              context = "global";
              loadingText = "Pushing ...";
              prompts = [
                {
                  type = "menuFromCommand";
                  title = "Which remote repository to push to?";
                  command = "bash -c \"git remote --verbose | grep '/.* (push)'\"";
                  filter = ''(?P<remote>.*)\s+(?P<url>.*) \(push\)'';
                  valueFormat = "{{ .remote }}";
                  labelFormat = "{{ .remote | bold | cyan }} {{ .url }}";
                }
                {
                  type = "menu";
                  title = "How to push?";
                  options = [
                    { value = "push"; }
                    { value = "push --force-with-lease"; }
                    { value = "push --force"; }
                  ];
                }
              ];
              command = "git {{index .PromptResponses 1}} {{index .PromptResponses 0}}";
            }
          ];
        };
      };
    }

    {
      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableScDaemon = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-gtk2;
      };

      programs.ssh = {
        enable = true;

        enableDefaultConfig = false;

        matchBlocks = mkMerge [
          {
            "*" = {
              # this applies to every config
              compression = true;
              controlMaster = "auto";
              controlPersist = "10m";
              serverAliveInterval = 60;
              serverAliveCountMax = 3;

              identitiesOnly = true;
              identityFile = "${config.home.homeDirectory}/.ssh/id_rsa_yubikey.pub";

              # other default values
              forwardAgent = false;
              addKeysToAgent = "no";
              hashKnownHosts = false;
              userKnownHostsFile = "~/.ssh/known_hosts";
              controlPath = "~/.ssh/master-%r@%n:%p";
            };

            "github.com".user = "git";
          }
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
  ];
}
