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
    # TODO: take a look at hm opitons
    git = {
      enable = true;
      userName = "weriomat";
      userEmail = "engel@weriomat.com";
      lfs.enable = true;
      extraConfig = {
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
          big = {
            user = "weriomat";
            hostname = "192.168.178.32";
            port = 2077;
          };
        };
    };
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableScDaemon = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };
}
