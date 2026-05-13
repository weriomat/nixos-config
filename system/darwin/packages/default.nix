{ pkgs, ... }:
{
  ###
  # Not installed via nix
  # Not available: cisco (tu vpn), powerpoint, pearcleaner, qmk toolbox, radio silence, via, vivid, vorta, wireguard
  # Broken package: mullvad-vpn
  # All licences can be found in the vaultwarden
  ###

  # TODO: merge with nixos conf
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    # macos only
    unstable.lima
    dogdns
    alt-tab-macos # alt tab with windows like overview
    stats # stats in bar
    monitorcontrol # control brightness of attached monitors
    (airbuddy.overrideAttrs (_: {
      src = fetchurl {
        name = "AirBuddy.dmg";
        url = "https://download.airbuddy.app/WebDownload/AirBuddy_v2.7.4.dmg";
        hash = "sha256-envrZqcWASJN8j7LTdbOpE9RjOe3yeX8FzFYCxU/QlQ=";
      };
    })) # infos about ble devices
    rectangle # window manager
    bartender # bar manager
    aldente # battery saver
    (coconutbattery.overrideAttrs (_: {
      src = fetchzip {
        url = "https://coconut-flavour.com/downloads/coconutBattery_${
          lib.replaceStrings [ "." "," ] [ "" "_" ] "4.2.0,192"
        }.zip";
        hash = "sha256-pzfg+RAlCbEaBHiU/ZQcBf0Tg0BCfs0UHh62dFQVbz0=";
      };
    })) # battery info

    # shared
    unstable.devenv
    localsend # airdrop
    keepassxc # password manager
    dust # newer "du"
    glow # fancy markdown viewer
    duf # df -> TODO: size is not reported right
    zotero

    # packages from homebrew
    cadical
    # calibre
    automake
    swi-prolog
    z3
    yubikey-manager
    yubikey-personalization
    # texinfo
    lua
    gdbm
    avrdude
    dfu-programmer
    dfu-util
    graphviz
    liblinear
    libspectre
    libssh2
    neovim
    openssh
    pyenv
    teensy-loader-cli
    gnupg

    # now other packages
    vim
    wget
    btop
    helix
    lazygit

    nmap

    cloc
    gnumake
    cmake
    cmake-format
    llvm-manpages

    llvm
    llvmPackages_latest.lldb
    extra-cmake-modules
    plasma5Packages.extra-cmake-modules
  ];
}
