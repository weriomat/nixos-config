{
  lib,
  pkgs,
  ...
}:
# TODO: improve hyprland config
# TODO: laptop power management
# TODO: brightnessctl
# TODO: waybar status -> corectl etc
# TODO: hyprland fix hyprland setup -> vimjoyer video
{
  imports = [
    ./wayland
    ./borg.nix
    ./sops.nix
  ];

  hardware.keyboard.qmk.enable = true;
  services = {
    # Firmware updates
    fwupd.enable = true;
    protonmail-bridge.enable = true;
  };

  # NOTE: this will punch a hole through the firewall
  programs = {
    localsend.enable = true;

    # for bsysprak
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

  # TODO: here
  # services.libinput = {
  #   enable = true;
  #   touchpad = {
  #     naturalScrolling = true;
  #     disableWhileTyping = true;
  #   };
  # };
  #  hardware.opentabletdriver = {
  #   enable = true;
  #   daemon.enable = true;
  # };

  #   let
  #   ports = {
  #     from = 1714;
  #     to = 1764;
  #   };
  # in
  # {
  #   networking.firewall = {
  #     allowedTCPPortRanges = [ ports ];
  #     allowedUDPPortRanges = [ ports ];
  #   };
  #   hm.services.kdeconnect = {
  #     enable = true;
  #     indicator = true;
  #   };
  # }

  # yanked from https://github.com/gvolpe/nix-config/blob/5cb1693b9926fab569e1a69e9cb3b2ce2ed09d2d/system/misc/groot.txt
  # Sudo custom prompt message
  security.sudo.configFile = ''
    Defaults lecture=always
    Defaults lecture_file=${./lecture.txt}
  '';

  # TODO: trackpad
  # services.libinput = {
  #   enable = true;
  #   touchpad.disableWhileTyping = true;
  # };

  # TODO: make a new name sceme for custom options + incorperate globals

  flatpack.enable = true;
  borg.enable = true;
  sops.enable = true;

  # TODO: here
  # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # programs.coolercontrol.enable = true;

  environment = {
    pathsToLink = [
      "/share/zsh"
      "/share/xdg-desktop-portal"
      "/share/applications"
    ]; # for zsh.enableCompletion
  };

  # hardware.keyboard.qmk.enable = true;
  # environment.systemPackages =  [
  #   pkgs.vial
  #   pkgs.via
  # ];

  # services = {
  #   smartd = {
  #     enable = true;
  #     autodetect = true;
  #   };
  #   libinput.enable = true; # TODO: here
  #   # avahi = {
  #   #   enable = true;
  #   #   nssmdns4 = true;
  #   #   openFirewall = true;
  #   # };
  #   # ipp-usb.enable = true;
  #   rpcbind.enable = false;
  #   nfs.server.enable = false;
  # };

  # TODO:  # -- Media Tools --
  # gimp
  # handbrake
  # mplayer
  # gthumb
  # jellyfin-media-player
  # jellyfin-mpv-shim
  # graphviz

  programs = {
    # Corectrl support - for managing CPU/GPU freq via a GUI
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };

    dconf.enable = true; # dconf -> edit system preferences
  };

  # programs.mtr.enable = true;
  # programs.fuse.userAllowOther = true;

  # TODO: here
  # services.udisks2.enable = true;

  # hardware = {

  #   graphics.enable = true; # for openGL

  # };

  audio.enable = true;
  doc.enable = true;
  graphical.enable = true;
  keyboard.enable = true;
  networking.enable = true;
  nix-settings.enable = true;
  packages.enable = true;
  virt.enable = true;

  # polkit_gnome lm_sensors meson
  # OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  #   pkgs.writeShellScriptBin "emopicker9000" ''
  #     # Get user selection via wofi from emoji file.
  #     chosen=$(cat $HOME/.emoji | ${pkgs.rofi-wayland}/bin/rofi -dmenu | awk '{print $1}')

  #     # Exit if none chosen.
  #     [ -z "$chosen" ] && exit

  #     # If you run this command with an argument, it will automatically insert the
  #     # character. Otherwise, show a message that the emoji has been copied.
  #     if [ -n "$1" ]; then
  # 	    ${pkgs.ydotool}/bin/ydotool type "$chosen"
  #     else
  #         printf "$chosen" | ${pkgs.wl-clipboard}/bin/wl-copy
  # 	    ${pkgs.libnotify}/bin/notify-send "'$chosen' copied to clipboard." &
  #     fi
  # ''

  # ssd thingie
  services.fstrim.enable = lib.mkDefault true;

  system.stateVersion = "23.11";

  # Take a look at https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/mac-randomize.nix
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
