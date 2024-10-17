{
  pkgs,
  lib,
  globals,
  ...
}: {
  services = {
    openssh.enable = false;
    udev.packages = [pkgs.yubikey-personalization];
    pcscd.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  programs.ssh = {
    startAgent = false;
  };

  environment.systemPackages = with pkgs; [
    paperkey
    yubikey-manager-qt
  ];

  home-manager.users.${globals.username} = {
    programs = {
      gpg = {
        enable = true;
        scdaemonSettings = {
          reader-port = "Yubico Yubi";
          disable-ccid = "";
        };
      };
      git = {
        enable = true;
        userName = "weriomat";
        userEmail = "engel@weriomat.com";
        lfs.enable = true;
        extraConfig = {
          safe.directory = "*";
          init.defaultBranch = "main";
        };
        signing = {
          signByDefault = true;
          # key = "008F5FA7F0C2803D";
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
        extraOptionOverrides = {
          IdentityFile = "/home/${globals.username}/.ssh/id_rsa_yubikey.pub";
        };

        extraConfig = "IdentitiesOnly yes";

        matchBlocks = let
          # tu_key = "/home/${globals.username}/.ssh/tu-gitlab.pub";
          # raspi_key = "/home/${globals.username}/.ssh/id_ed25519";
          hetzner_key = "/home/${globals.username}/.ssh/deploy_hetzner";
        in {
          "github.com" = {user = "git";};
          "git.tu-berlin.de" = {
            user = "git";
            # identityFile = tu_key;
          };
          # raspi = {
          #   hostname = "192.168.178.21";
          #   user = "marts";
          #   identityFile = raspi_key;
          #   port = 2077;
          # };
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
            identityFile = hetzner_key;
          };
          big = {
            user = "weriomat";
            hostname = "192.168.178.32";
            port = 2077;
            identityFile = hetzner_key;
          };
        };
      };
    };
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    home.sessionVariables = rec {
      XDG_RUNTIME_DIR = "/run/user/1000/";
      SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}gnupg/S.gpg-agent.ssh";
    };
  };
}
