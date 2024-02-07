{inputs, ...}: {
  # inputs.self, inputs.nix-darwin, and inputs.nixpkgs can be accessed here

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    # fzf
    enableFzfCompletion = true;
    enableFzfGit = true; # ctrl-g
    enableFzfHistory = true; # ctrl-r
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision =
    inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.eliasengel = {
    name = "eliasengel";
    home = "/Users/eliasengel";
  };

  # checks config for data type mismatches
  nix.checkConfig = true;

  # is the default -> all users are allowed -> priveleged users always are allowed
  nix.settings = {
    allowed-users = ["*"];
    auto-optimise-store = true;
    sandbox = true;
  };
  nixpkgs.config = {allowUnfree = true;};

  programs = {
    info.enable = true;
    man.enable = true;
    # nix-index.enable = true; -> moved to hm
    tmux = {
      enable = true;
      enableFzf = true;
      enableMouse = true;
      enableSensible = true;
      enableVim = true;
      # extraConfig = '''';
    };
  };

  # use touchID for sudo auth
  # security.pam.enableSudoTouchIdAuth = true;

  # false is default -> https://daiderd.com/nix-darwin/manual/index.html#opt-services.cachix-agent.enable
  # services.cachix-Agent-enable = false;

  # TODO: windowmanager to take a look at, take a look at kwm wm
  services.chunkwm.enable = false;

  # TODO: take a look at dnsmasq

  # TODO: take a look at -> https://daiderd.com/nix-darwin/manual/index.html#opt-services.hercules-ci-agent.enable
  services.hercules-ci-agent.enable = false;

  # TODO: take a look at ipfs

  # TODO: tgake a look at these hotkey daemons
  services.karabiner-elements.enable = false;
  services.khd.enable = false;
  services.skhd.enable = false;

  # TODO: take a look at
  services.lorri.enable = false;

  # TODO: take a look at this
  services.sketchybar.enable = false;

  # TODO: take a look at
  services.spacebar.enable = false;

  # TODO: maybe monitor mac with telegraf and db and graphana xd
  services.telegraf.enable = false;

  # TODO: look at this
  services.yabai.enable = false;

  # TODO: take a look at -> system.defaults.ActivityMonitor.IconType system.defaults.ActivityMonitor.OpenMainWindow system.defaults.CustomSystemPreferences

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  # system.defaults.NSGlobalDomain.AppleFontSmoothing

  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically =
    false;

  # system.defaults.NSGlobalDomain.AppleKeyboardUIMode

  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";

  # NOTE: non default
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # system.defaults.NSGlobalDomain.AppleScrollerPagingBehavior

  system.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";

  # system.defaults.NSGlobalDomain.AppleWindowTabbingMode
  # system.defaults.NSGlobalDomain.InitialKeyRepeat
  # system.defaults.NSGlobalDomain.KeyRepeat

  # NOTE: no default
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

  # system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled
  # system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled
  # system.defaults.NSGlobalDomain.NSDisableAutomaticTermination
  # system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud
  # system.defaults.NSGlobalDomain.NSScrollAnimationEnabled
  # system.defaults.NSGlobalDomain."com.apple.keyboard.fnState"
  # system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior"
  # system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick"
  # system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates
  # system.defaults.alf.allowdownloadsignedenabled
  # system.defaults.dock.enable-spring-load-actions-on-all-items
  # system.defaults.dock.autohide
  # TODO: configure dock
  # TODO: configure finder
  # TODO: configure loginwindow
  # system.defaults.menuExtraClock.IsAnalog
  # system.defaults.screencapture.disable-shadow
  # system.defaults.screencapture.type
  # system.defaults.screensaver.askForPasswordDelay
  # TODO: configure trackpad
  # TODO: configure universalaccess
  # TODO: configure keyboard
  # time.timeZone
  # TODO: configure users

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
