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
    # scroll-reverser # Different scroll style for mouse vs. trackpad
    # mqtt-explorer
    unstable.lima
    doggo
    alt-tab-macos # alt tab with windows like overview
    stats # stats in bar
    monitorcontrol # control brightness of attached monitors
    rectangle # window manager

    (bartender.overrideAttrs (finalAttrs: {
      src = fetchzip {
        url = "https://downloads.macbartender.com/B2/updates/${
          builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
        }/Bartender%20${lib.versions.major finalAttrs.version}.zip";
        hash = "sha256-UtLTfRhL7JTYzQXf7kyYyGZXy1TLJ0ODk1nRs2pLfQ4=";
      };
    })) # bar manager
    aldente # battery saver
    coconutbattery # battery info

    # shared
    unstable.devenv
    localsend # airdrop
    keepassxc # password manager
    dust # newer "du"
    glow # fancy markdown viewer
    duf # df -> TODO: size is not reported right

    zotero # install better-bibtex plugin

    # packages from homebrew
    yubikey-manager
    yubikey-personalization
    libssh2
    openssh
    gnupg

    # now other packages
    vim
    nmap
    cloc
  ];
}
