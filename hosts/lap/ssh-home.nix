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
      settings = {
        # # stolen from https://github.com/jvanbruegge/nix-config/blob/master/gpg.nix
        # # https://github.com/drduh/config/blob/master/gpg.conf
        # # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
        # # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
        # # Use AES256, 192, or 128 as cipher
        # personal-cipher-preferences = "AES256 AES192 AES";

        # # Use SHA512, 384, or 256 as digest
        # personal-digest-preferences = "SHA512 SHA384 SHA256";

        # # Use ZLIB, BZIP2, ZIP, or no compression
        # personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

        # # Default preferences for new keys
        # default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

        # # SHA512 as digest to sign keys
        # cert-digest-algo = "SHA512";

        # # SHA512 as digest for symmetric ops
        # s2k-digest-algo = "SHA512";

        # # AES256 as cipher for symmetric ops
        # s2k-cipher-algo = "AES256";

        # # UTF-8 support for compatibility
        # charset = "utf-8";

        # # Show Unix timestamps
        # fixed-list-mode = true;

        # # No comments in signature
        # no-comments = true;

        # # No version in signature
        # no-emit-version = true;

        # # Long hexidecimal key format
        # keyid-format = "0xlong";

        # # Display UID validity
        # list-options = "show-uid-validity";
        # verify-options = "show-uid-validity";

        # # Display all keys and their fingerprints
        # with-fingerprint = true;

        # # Cross-certify subkeys are present and valid
        # require-cross-certification = true;

        # # Disable caching of passphrase for symmetrical ops
        # no-symkey-cache = true;

        # # Enable smartcard
        # use-agent = true;
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
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  home.sessionVariables = rec {
    XDG_RUNTIME_DIR = "/run/user/1000";
    SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh";
  };
}
