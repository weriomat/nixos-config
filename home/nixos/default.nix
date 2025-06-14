{
  pkgs,
  inputs,
  globals,
  ...
}:
{
  imports = [
    ../shared
    ./xdg.nix
  ];
  # TODO: sytembus notify
  # services.systembus-notify = {};

  # NOTE: vscodium disabled since tex stuff works
  discord.enable = true;
  firefox = {
    enable = true;
    arkenfox.enable = true;
  };
  hyprland.enable = true;
  kitty.enable = true;
  thunderbird.enable = true;

  # TODO: gtk, hyprland, waybar
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";

    obs.enable = true;
  };

  # git things to take a look at
  # TODO: git.delta; git.diff-so-fancy; git.hooks
  # NOTE: maybe this works with githooks nix
  # TODO: global search git -> what do i have ...

  # TODO: nice hud to see gpu stats; with steam
  # programs.mangohud = {};

  # TODO: entweder vlc or mpv
  #  programs.mpv = {
  #   enable = true;
  #   defaultProfiles = ["gpu-hq"];
  #   scripts = [pkgs.mpvScripts.mpris];
  # };

  services = {
    # NOTE: notifications about power
    poweralertd.enable = true;

    # set this up for macos s well
    pueue = {
      enable = true;
      settings = {
        daemon = {
          default_parallel_tasks = 2;
        };
        client = {
          dark_mode = true;
        };
      };
    };
  };

  programs = {
    jq = {
      enable = true;
      colors = {
        null = "1;30";
        false = "0;31";
        true = "0;32";
        numbers = "0;36";
        strings = "0;33";
        arrays = "1;35";
        objects = "1;35";
        objectKeys = "1;37";
      };
    };

    tealdeer = {
      enable = true; # tldr written in rust
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
          auto_update_interval_hours = 168;
        };
      };
    };
  };

  # TODO: if nextcloud
  # services.nextcloud-client = {};

  # TODO: all good things with pdf
  # services.signaturepdf = {};

  # TODO: fusuma
  # services.fusuma = {}; # gestures for trackpad

  # TODO: yt
  # programs.freetube = {
  #   enable = true;
  #   settings = {
  #     allowDashAv1Formats = true;
  #     checkForUpdates = false;
  #     defaultQuality = "1080";
  #     baseTheme = "catppuccinMocha";
  #   };
  # };

  # TODO: programs.yt-dlp = {}; # Dowoloader for yt files

  manual = {
    html.enable = true; # `home-manager-help`
    json.enable = true; # creates all hm options as a json
    manpages.enable = true; # `man home-configuration.nix`
  };

  home = rec {
    inherit (globals) username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11"; # Has not to be changed
    packages = builtins.attrValues (import ./scripts { inherit pkgs globals inputs; });
    # Add ./local/bin to $PATH
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
    preferXdgDirectories = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
