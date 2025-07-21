_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
      lockfiles = false; # Don't save lockfile (since running from anywhere)
    };
    taps = [
      # "homebrew/cask" # Required for casks
      "homebrew/cask-drivers" # Used for Logitech G-Hub
      "homebrew/bundle"
      "homebrew/services"
      "osx-cross/arm"
      "osx-cross/avr"
      "qmk/qmk"
      "borgbackup/tap"
    ];
    brews = [
      "trash" # Delete files and folders to trash instead of rm
      "openjdk" # Required by Apache Directory Studio
      "bootloadhid"
      "hopenpgp-tools"
      "openjdk@17"
      "osx-cross/arm/arm-none-eabi-gcc@8"
      "osx-cross/avr/avr-gcc@8"
      "pcre"
      "pillow"
      "pinentry-mac"
      "qmk/qmk/hid_bootloader_cli"
      "qmk/qmk/mdloader"
      "qmk/qmk/qmk"
      "avrdude"
      "screenresolution"
      "borgbackup/tap/borgbackup-fuse"
      "apache-activemq"
    ];
    casks = [
      # "scroll-reverser" # Different scroll style for mouse vs. trackpad
      # "logitech-g-hub" # Mouse and keyboard management
      # "obsidian" # Obsidian packaging on Nix is not available for macOS
      # "steam" # Not packaged for Nix
      # "apache-directory-studio" # Packaging on Nix is not available for macOS
      "balenaetcher"
      "mqtt-explorer"
      "qmk-toolbox"
      # "skim" # bad pdf reader, prefer firefox
      "wireshark-chmodbpf"
      # "vorta"
      "macfuse"
      # "qmk-toolbox"
    ];
  };
}
