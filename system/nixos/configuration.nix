{
  lib,
  pkgs,
  ...
}:
# TODO: laptop power management
{
  imports = [ ./wayland ];

  hardware.keyboard.qmk.enable = true;
  services = {
    fwupd.enable = true; # Firmware updates
    protonmail-bridge.enable = true;
    fstrim.enable = lib.mkDefault true; # ssd thingie
    # TODO: kdeconnect.enable = true;
    # TODO: libinput = { # enabled by default, handles input
    #   enable = true;
    #   touchpad.disableWhileTyping = true;
    # };
    # TODO: avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
  };

  programs = {
    # TODO: mtr.enable = true;

    # Corectrl support - for managing CPU/GPU freq via a GUI
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };

    dconf.enable = true; # dconf -> edit system preferences
    # NOTE: this will punch a hole through the firewall
    localsend.enable = true;

    # nice gui for cooling temps
    coolercontrol.enable = true;

    # the shared of objects of the listed libs will be provided
    # via the environment variable `NIX_LD_LIBRARY_PATH`
    nix-ld = {
      enable = true;
      libraries = [
        pkgs.zlib
        pkgs.gmp
        pkgs.mpfr
        pkgs.libmpc
        pkgs.glib
        pkgs.pixman
        pkgs.expat
        pkgs.ncurses5
      ];
    };
  };

  # yanked from https://github.com/gvolpe/nix-config/blob/5cb1693b9926fab569e1a69e9cb3b2ce2ed09d2d/system/misc/groot.txt
  # Sudo custom prompt message
  security.sudo.configFile = ''
    Defaults lecture=always
    Defaults lecture_file=${./lecture.txt}
  '';

  # TODO: make a new name sceme for custom options + incorperate globals
  flatpack.enable = true;
  borg.enable = true;
  sops.enable = true;

  environment.pathsToLink = [
    "/share/zsh"
    "/share/xdg-desktop-portal"
    "/share/applications"
  ]; # for zsh.enableCompletion

  audio.enable = true;
  doc.enable = true;
  graphical.enable = true;
  keyboard.enable = true;
  networking.enable = true;
  nix-settings.enable = true;
  packages.enable = true;
  virt.enable = true;

  system.stateVersion = "23.11";

  # TODO: Take a look at https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/mac-randomize.nix
  # # Enable MAC Randomize
  # systemd.services.macchanger = {
  #   enable = true;
  #   description = "Change MAC address";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.macchanger}/bin/macchanger -r wlp0s20f3";
  #     ExecStop = "${pkgs.macchanger}/bin/macchanger -p wlp0s20f3";
  #     RemainAfterExit = true;
  #   };
  # };
}
