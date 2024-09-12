{
  pkgs,
  inputs,
  globals,
  ...
}: {
  discord.enable = true;
  firefox.enable = true;
  hyprland.enable =
    if globals.isLaptop
    then false
    else true;

  vscode.enable = true;
  kitty.enable = true;
  thunderbird.enable = true;

  # TODO: gtk, hyprland, waybar
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  # git things to take a look at
  # TODO: git.delta; git.diff-so-fancy; git.hooks
  # NOTE: maybe this works with githooks nix

  # TODO: calender for cli -> khal

  # TODO: nice hud to see gpu stats
  # programs.mangohud = {};

  # TODO: entweder vlc or mpv
  #  programs.mpv = {
  #   enable = true;
  #   defaultProfiles = ["gpu-hq"];
  #   scripts = [pkgs.mpvScripts.mpris];
  # };

  # TODO: organize academic research papers
  # programs.pubs = {};

  # NOTE: bitwarden cli client
  # programs.rbw = {};

  # TODO: global search git -> what do i have ...
  # TODO: jq

  # set this up for macos s well
  services.pueue = {
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

  # TODO: config
  # services.poweralertd.enable = true;

  # TODO: battery notifys
  # services.batsignal = {};

  # home.packages = [pkgs.pciutils]; # lspci, setpci

  # TODO: tmate

  # TODO: here
  # xdg = {
  #   enable = true;
  # };

  # TODO: wlsunset -> i have other services like this enabled -> search for them
  # services.redshift.enable = true; # TODO: here wlrsunset is availdbe as well, or use `services.gammastep`

  # TODO: cbatticon for laptop

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
        objects = "1;37";
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
          auto_update_interval_hours = 24;
        };
      };
    };

    # TODO: move this into own file + add zsh thingies + config
    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
    };
  };

  # css for discord
  # programs.discocss = {
  #   enable = true;
  #   css = ''
  #     @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
  #   '';
  #   discordAlias = true; # alias discocss to discord
  #   discordPackage = pkgs.discord;
  # };

  # TODO: dashboard
  # services.glance = {};

  # TODO: here
  # services.network-manager-applet.enable = true;

  # TODO: if nextcloud
  # services.nextcloud-client = {};

  # TODO: all good things with pdf
  # services.signaturepdf = {};

  # TODO: sytembus notify
  # services.systembus-notify = {};

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

  # TODO: here
  # programs.texlive = {
  #   enable = true;
  #   packageSet =
  #     pkgs.texlive.combined.scheme-full;
  # };

  # TODO: programs.yt-dlp = {}; # Dowoloader for yt files

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  # TODO: # disable manuals as nmd fails to build often
  manual = {
    html.enable = true; # `home-manager-help`
    json.enable = true; # creates all hm options as a json
    manpages.enable = true; # `man home-configuration.nix`
  };

  home = rec {
    inherit (globals) username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11"; # Has not to be changed
    packages = builtins.attrValues (import ../config/scripts {inherit pkgs globals inputs;});
    # Add ./local/bin to $PATH
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
    # preferXdgDirectories = true;
  };

  # TODO: here
  # nix.registry = {};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
