{
  config,
  globals,
  pkgs,
  ...
}:
{
  programs = {
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      scdaemonSettings = {
        reader-port = "Yubico Yubi";
        disable-ccid = "";
      };
    };
    # TODO: take a look at hm options
    git = {
      enable = true;
      userName = "weriomat";
      userEmail = "engel@weriomat.com";
      lfs.enable = true;
      extraConfig = {
        # TODO: diff tool difft https://difftastic.wilfred.me.uk/git.html
        # TODO: merge mergiraf https://mergiraf.org/usage.html
        safe.directory = "*";
        init.defaultBranch = "main";
        tag.gpgSign = true;
        # NOTE: do not rebase by default
        pull.rebase = false;
      };
      signing = {
        signByDefault = true;
        key = "E64AE4E613602685";
      };
    };
    ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPersist = "10m";
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      extraOptionOverrides.IdentityFile = "/home/${globals.username}/.ssh/id_rsa_yubikey.pub";

      extraConfig = "IdentitiesOnly yes";

      matchBlocks =
        let
          hetzner_key = "/home/${globals.username}/.ssh/deploy_hetzner";
        in
        {
          # git services
          "github.com".user = "git";
          "git.tu-berlin.de".user = "git";
          "gitlab.cobalt.rocks".user = "git";

          # selfhosted
          storage = {
            user = "u406968";
            hostname = "u406968.your-storagebox.de";
            port = 23;
            identityFile = hetzner_key;
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
            hostname = "192.168.178.111";
            port = 2077;
          };
          bb = {
            user = "weriomat";
            hostname = "192.168.178.110";
            port = 2077;
          };
          big = {
            user = "weriomat";
            hostname = "10.100.0.5";
            port = 2077;
          };
        };
    };
  };
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gtk2;
    };

    # NOTE: kanshi is configured at the host level
    kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile = {
            name = "undocked";
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
        }
        {
          profile = {
            name = "new";
            outputs = [
              {
                # internal display
                criteria = "eDP-1";
                status = "enable";
                mode = "1920x1200@60";
                scale = 1.0;
              }
              {
                criteria = "LG Electronics LG ULTRAGEAR+";
                status = "enable";
                mode = "3840x2160@95";
              }
              {
                criteria = "Acer Technologies VG270U P 0x1071B314";
                status = "enable";
                # mode = "1920x1080@120"; # TODO: check if 1440p works
                scale = 1.0;
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                # internal display
                criteria = "eDP-1";
                status = "enable";
                mode = "1920x1200@60";
                scale = 1.0;
              }
              {
                criteria = "Lenovo Group Limited Y25-30 U3W0DYXB";
                status = "enable";
                mode = "1920x1080@240";
                scale = 1.0;
              }
              {
                criteria = "Acer Technologies VG270U P 0x1071B314";
                status = "enable";
                mode = "1920x1080@120"; # TODO: check if 1440p works
                scale = 1.0;
              }
            ];
          };
        }
      ];
    };
  };
}
