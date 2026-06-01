{ pkgs, ... }:
{
  # TODO: XDG NINJA
  # TODO: package vorta for darwin
  # TODO: export borg key for darwin repo
  # TODO: firefox
  ###
  # Not installed via nix
  # Not available: cisco (tu vpn), powerpoint, pearcleaner, qmk toolbox, radio silence, via, vivid, vorta, wireguard
  # Broken package: mullvad-vpn
  # All licences can be found in the vaultwarden
  ###

  # TODO: use wireshark/ wireshark-chmodbpf
  # TODO: obsidian
  # TODO: steam
  # TODO: avrdude
  # TODO: bootloadhid
  # TODO: qmk (mdloader/qmk/hid_bootloader_cli)
  # TODO: merge with nixos conf
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    # macos only
    # TODO: here
    # scroll-reverser # Different scroll style for mouse vs. trackpad
    # mqtt-explorer
    unstable.lima
    doggo
    alt-tab-macos # alt tab with windows like overview
    stats # stats in bar
    monitorcontrol # control brightness of attached monitors
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

    unstable.zotero # install better-bibtex plugin

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
