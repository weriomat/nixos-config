{
  pkgs,
  lib,
  ...
}: {
  services = {
    openssh.enable = false;
    udev.packages = [pkgs.yubikey-personalization];
    pcscd.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  programs.ssh = {
    # enableAskPassword = true;
    # askPassword = "${pkgs.plasma5Packages.ksshaskpass}/bin/ksshaskpass";
    startAgent = false;
  };

  environment.systemPackages = with pkgs; [
    paperkey
    yubikey-manager-qt
  ];

  home-manager.users.marts = {
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        reader-port = "Yubico Yubi";
        disable-ccid = "";
      };
    };
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
    };
    home.sessionVariables = rec {
      XDG_RUNTIME_DIR = "/run/user/1000/";
      SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}gnupg/S.gpg-agent.ssh";
    };

    programs.git = {
      enable = true;
      userName = "weriomat";
      userEmail = "eliasaengel@gmail.com";
      lfs.enable = true;
      extraConfig = {
        safe.directory = "*";
        init.defaultBranch = "main";
      };
      signing = {
        signByDefault = true;
        key = "008F5FA7F0C2803D";
      };
    };
    programs.ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPersist = "10m";
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      extraOptionOverrides = {
        # IdentityFile = "/home/marts/.ssh/id_ed25519.pub";
        IdentityFile = "/home/marts/.ssh/id_rsa_yubikey.pub";
      };

      extraConfig = "IdentitiesOnly yes";

      matchBlocks = let
        tu_key = "/home/marts/.ssh/tu-gitlab.pub";
      in {
        "github.com" = {user = "git";};
        "git.tu-berlin.de" = {
          user = "git";
          identityFile = tu_key;
        };
      };
    };
  };
}
