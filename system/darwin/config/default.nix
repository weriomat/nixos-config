{
  inputs,
  outputs,
  lib,
  ...
}:
{
  # inputs.self, inputs.nix-darwin, and inputs.nixpkgs can be accessed here

  documentation = {
    enable = true;
    man.enable = true;
    # dev.enable = true;
    doc.enable = true;
    # nixos.enable = true;
    info.enable = true;
  };

  networking = {
    # TODO: applicationFirefall
    wakeOnLan.enable = false;
    dns = [
      # see https://developers.cloudflare.com/1.1.1.1/ip-addresses/#1111
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
      "2606:4700:4700::1111#one.one.one.one"
      "2606:4700:4700::1001#one.one.one.one"

      # see https://www.quad9.net/service/service-addresses-and-features
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
    domain = "weriomat.com";
    search = [ "weriomat.com" ];
    # TODO: computerName
    # TODO: hostName
  };

  # power.sleep.computer = "";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.unstable-packages
    ];
  };
  # Necessary for using flakes on this system.
  nix = {
    channel.enable = false;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "unstable=${inputs.nixpkgs-unstable}"
    ];

    # stolen from https://git.cobalt.rocks/shared-configs/nixos-ng/-/blob/main/modules/nix.nix?ref_type=heads
    # enable local registry for better search
    # https://discourse.nixos.org/t/local-flake-based-nix-search-nix-run-and-nix-shell/13433/12
    registry = lib.attrsets.genAttrs (builtins.attrNames inputs) (name: {
      flake = inputs.${name};
    });
    settings.experimental-features = "nix-command flakes";
    # checks config for data type mismatches
    checkConfig = true;
    # is the default -> all users are allowed -> privileged users always are allowed
    settings = {
      allowed-users = [ "*" ];
      sandbox = true;
    };
    optimise.automatic = true;
    gc.automatic = true;
    auto-optimize-store = true;
    warn-dirty = false;

    linux-builder = {
      enable = true;
      config.virtualisation.cores = 8;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    # fzf
    enableFzfCompletion = true;
    enableFzfGit = true; # ctrl-g
    enableFzfHistory = true; # ctrl-r
  };

  # Set Git commit hash for darwin-version.
  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  users.users.eliasengel = {
    name = "eliasengel";
    home = "/Users/eliasengel";
  };

  programs = {
    info.enable = true;
    man.enable = true;
    nix-index.enable = true;
  };

  nix.enable = true;
  system.primaryUser = "eliasengel";

  services = {
    # Auto upgrade nix package and the daemon service.
    # nix-daemon.enable = true;

    # TODO: windowmanager to take a look at, take a look at kwm wm
    chunkwm.enable = false;
    # TODO: take a look at -> https://daiderd.com/nix-darwin/manual/index.html#opt-services.hercules-ci-agent.enable
    hercules-ci-agent.enable = false;
    # TODO: tgake a look at these hotkey daemons
    karabiner-elements.enable = false;
    khd.enable = false;
    skhd.enable = false;
    # TODO: take a look at
    lorri.enable = false;

    # TODO: take a look at this
    sketchybar.enable = false;

    # TODO: take a look at
    spacebar.enable = false;

    # TODO: maybe monitor mac with telegraf and db and graphana xd
    telegraf.enable = false;

    # TODO: look at this
    yabai.enable = false;

    # TODO: look at this
    jankyborders.enable = false;
  };

  # TODO: provision user
  # users.users

  # use touchID for sudo auth
  # security.pam.enableSudoTouchIdAuth = true;

  # false is default -> https://daiderd.com/nix-darwin/manual/index.html#opt-services.cachix-agent.enable
  # services.cachix-Agent-enable = false;

  # TODO: take a look at dnsmasq

  # TODO: take a look at ipfs

  # TODO: take a look at -> system.defaults.ActivityMonitor.IconType system.defaults.ActivityMonitor.OpenMainWindow system.defaults.CustomSystemPreferences

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        # AppleFontSmoothing

        AppleInterfaceStyleSwitchesAutomatically = false;

        # AppleKeyboardUIMode

        AppleMeasurementUnits = "Centimeters";

        # NOTE: non default
        ApplePressAndHoldEnabled = false;

        # AppleScrollerPagingBehavior

        AppleTemperatureUnit = "Celsius";

        # AppleWindowTabbingMode
        # InitialKeyRepeat
        # KeyRepeat

        # NOTE: no default
        NSAutomaticPeriodSubstitutionEnabled = false;

        # NSAutomaticSpellingCorrectionEnabled
        # NSAutomaticWindowAnimationsEnabled
        # NSDisableAutomaticTermination
        # NSDocumentSaveNewDocumentsToCloud
        # NSScrollAnimationEnabled
        # "com.apple.keyboard.fnState"
        # "com.apple.mouse.tapBehavior"
        # "com.apple.trackpad.enableSecondaryClick"
      };
      # SoftwareUpdate.AutomaticallyInstallMacOSUpdates
      # alf.allowdownloadsignedenabled
      # dock.enable-spring-load-actions-on-all-items
      # dock.autohide
      # TODO: configure dock
      # TODO: configure finder
      # TODO: configure loginwindow
      # menuExtraClock.IsAnalog
      # screencapture.disable-shadow
      # screencapture.type
      # screensaver.askForPasswordDelay
    };
    # TODO: configure trackpad
    # TODO: configure universalaccess
    # TODO: configure keyboard
  };
  # time.timeZone
  # TODO: configure users

  # The platform the configuration will be used on.
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = "aarch64-darwin";
  };
}
