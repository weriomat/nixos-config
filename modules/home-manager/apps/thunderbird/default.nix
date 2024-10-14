{
  globals,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.thunderbird.enable = mkEnableOption "Enable Thunderbird";

  config = mkIf config.thunderbird.enable {
    # dont forget to launch proton-mail bridge with `protonmail-bridge -n`
    accounts.email = {
      # Sign in manually first and than it works; zib manually -> well we overwrite it every time
      accounts = let
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = true;
            # certificatesFile = "";
            useStartTls = true;
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = true;
            # certificatesFile = /home/marts/email;
            useStartTls = true;
          };
        };
        # gpg = {
        #   encryptByDefault = true;
        #   key = "0x008F5FA7F0C2803D";
        #   signByDefault = true;
        # };
        thunderbird = {
          enable = true;
          # perIdentitySettings = {};
          # profiles = [];
          # settings = {};
        };
        signature = {
          text = "Elias Engel";
          delimiter = "~*~*~*~*~*~*~*~*~*~*~*~";
          showSignature = "append";
          command = pkgs.writeScript "signature" "echo Elias Engel";
        };
        imapnotify = {
          enable = true;
          boxes = ["Inbox"];
          extraConfig = {wait = 2;};
          onNotify = ""; # execute shell command
        };
      in {
        weriomat = {
          address = "weriomat@weriomat.com";
          realName = "weriomat";
          primary = false;
          # aliases = [];
          flavor = "plain"; # this is important
          # getmail = {};
          userName = "weriomat@weriomat.com";
          # passwordCommand = "pass -c EMAIL/weriomat";
          # inherit gpg;
          inherit imap smtp thunderbird signature imapnotify;

          # aerc
          # alot
          # asteroid

          # jmap = {};
          # lieer = {};
          # maildir = {
          #   path = "";
          # };
          # mysync = {};
          # msmtp = {};
          # mu.enable = true;
          # mujmap = {};
          # neomutt = {};
          # notmuch = 0 {};
          # offlineimap = {};
          # passwordCommand = "";
          # primary = false;
        };
        kleinanzeigen = {
          address = "kleinanzeigen@weriomat.com";
          realName = "kleinanzeigen";
          primary = false;
          # aliases = [];
          flavor = "plain"; # this is important
          # getmail = {};

          userName = "kleinanzeigen@weriomat.com";
          inherit imap smtp thunderbird signature imapnotify;
          # inherit gpg;

          # jmap = {};
          # lieer = {};
          # maildir = {
          #   path = "";
          # };
          # mysync = {};
          # msmtp = {};
          # mu.enable = true;
          # mujmap = {};
          # neomutt = {};
          # notmuch = 0 {};
          # offlineimap = {};
        };
        engel = {
          address = "engel@weriomat.com";
          realName = "Engel";
          primary = true;
          # aliases = [];
          flavor = "plain"; # this is important
          # getmail = {};
          userName = "engel@weriomat.com";

          # inherit gpg;
          inherit imap smtp thunderbird signature imapnotify;

          # jmap = {};
          # lieer = {};
          # maildir = {
          #   path = "";
          # };
          # mysync = {};
          # msmtp = {};
          # mu.enable = true;
          # mujmap = {};
          # neomutt = {};
          # notmuch = 0 {};
          # offlineimap = {};
        };
        uni = {
          address = "uni@weriomat.com";
          realName = "Elias Engel";
          primary = false;
          # aliases = [];
          flavor = "plain"; # this is important
          # getmail = {};
          userName = "uni@weriomat.com";
          # inherit gpg;
          inherit imap smtp thunderbird signature imapnotify;

          # jmap = {};
          # lieer = {};
          # maildir = {
          #   path = "";
          # };
          # mysync = {};
          # msmtp = {};
          # mu.enable = true;
          # mujmap = {};
          # neomutt = {};
          # notmuch = 0 {};
          # offlineimap = {};
        };
      };
      # certificatesFile = "";
      # maildirBasePath = "";
    };

    home.packages = with pkgs; [protonmail-bridge pass-wayland];

    programs.thunderbird = {
      enable = true;
      profiles = {
        ${globals.username} = {
          extraConfig = ""; # add to user.js
          settings = {}; # same ass extra config
          isDefault = true;
          userChrome = ""; # add to user crome css
          userContent = "";
          withExternalGnupg = true;
        };
      };
      settings = {};
    };
  };
}
# eae = {
#   address = "eliasaengel@gmail.com";
#   aliases = [];
#   flavor = "gmail.com"; # this is important
#   folders = {
#     # drafts = "";
#     # inbox = "";
#     # sent = "";
#     # trash = "";
#   };
#   # getmail = {};
#   # gpg = {
#   #   encryptByDefault = true;
#   #   key = "";
#   #   signByDefault = true;
#   # };
#   # imap = {
#   #   host = "";
#   #   port = 9;
#   #   tls = {
#   #     enable = true;
#   #     certificatesFile = "";
#   #     useStartTls = true;
#   #   };
#   # };
#   imapnotify = {
#     enable = true;
#     boxes = ["Inbox"];
#     extraConfig = {wait = 2;};
#     onNotify = ""; # execute shell command
#   };
#   # jmap = {};
#   # lieer = {};
#   # maildir = {
#   #   path = "";
#   # };
#   # mysync = {};
#   # msmtp = {};
#   # mu.enable = true;
#   # mujmap = {};
#   # neomutt = {};
#   # notmuch = 0 {};
#   # offlineimap = {};
#   # passwordCommand = "";
#   primary = false;
#   realName = "Elias";
#   signature = {
#     text = "Elias Engel";
#     delimiter = "~*~*~*~*~*~*~*~*~*~*~*~";
#     showSignature = "append";
#     command = pkgs.writeScript "signature" "echo Elias Engel";
#   };
#   # smtp = {};
#   thunderbird = {enable = true;};
#   # userName = "";
# };

