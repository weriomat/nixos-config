{inputs, ...}: {
  # inputs.self, inputs.nix-darwin, and inputs.nixpkgs can be accessed here

  documentation = {
    enable = true;
    man.enable = true;
    # dev.enable = true;
    doc.enable = true;
    # nixos.enable = true;
    info.enable = true;
  };

  # Necessary for using flakes on this system.
  nix = {
    settings.experimental-features = "nix-command flakes";
    # checks config for data type mismatches
    checkConfig = true;
    # is the default -> all users are allowed -> privileged users always are allowed
    settings = {
      allowed-users = ["*"];
      auto-optimise-store = true;
      sandbox = true;
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
    configurationRevision =
      inputs.self.rev or inputs.self.dirtyRev or null;

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
    tmux = {
      enable = true;
      enableFzf = true;
      enableMouse = true;
      enableSensible = true;
      enableVim = true;
      # extraConfig = '''';
    };
  };

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;

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
  };

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

        AppleInterfaceStyleSwitchesAutomatically =
          false;

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
    config = {allowUnfree = true;};
    hostPlatform = "aarch64-darwin";
  };
}
