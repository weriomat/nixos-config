{
  pkgs,
  globals,
  ...
}:
{
  programs.gnupg.agent = {
    #TODO: https://github.com/jakehamilton/config/blob/main/modules/darwin/security/gpg/default.nix
    enable = true;
    enableSSHSupport = true;
  };
  home-manager.users.${globals.username} = {
    home.packages = [
      # yubikey-manager4
      pkgs.yubikey-manager
      pkgs.yubikey-personalization
      pkgs.git
    ];
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
        # signing = {
        #   signByDefault = true;
        #   key = "008F5FA7F0C2803D";
        # };
      };
      ssh = {
        enable = true;
        compression = true;
        controlMaster = "auto";
        controlPersist = "10m";
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        extraOptionOverrides = {
          IdentityFile = "/Users/${globals.username}/.ssh/id_rsa_yubikey.pub";
        };

        extraConfig = "IdentitiesOnly yes";

        matchBlocks =
          let
            tu_key = "/Users/${globals.username}/.ssh/id_ed25519";
            hetzner_key = "/Users/${globals.username}/.ssh/deploy_hetzner";
          in
          {
            "github.com" = {
              user = "git";
              identityFile = "/Users/${globals.username}/.ssh/github";
            };
            "git.tu-berlin.de" = {
              user = "git";
              identityFile = tu_key;
            };
            "gitlab.cobalt.rocks" = {
              user = "git";
              port = 3724;
              identityFile = tu_key;
            };
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
          };
      };
    };
    # systemd service
    # services.gpg-agent = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   enableScDaemon = true;
    #   enableSshSupport = true;
    # };
    # is set via gnupg
    # home.sessionVariables = rec {
    # XDG_RUNTIME_DIR = "/run/user/1000/";
    # SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}gnupg/S.gpg-agent.ssh";
    # };
  };
}
