{
  lib,
  pkgs,
  globals,
  ...
}:
# TODO: gnome polkit
# TODO: improve hyprland config
# TODO: laptop power management
# TODO: brightnessctl
# TODO: waybar status -> corectl etc
# TODO: hyprland fix hyprland setup -> vimjoyer video
# TODO: cloudflare dns
{
  imports = [
    ./wayland
    ./borg.nix
    ./sops.nix
  ];

  # TODO: make a new name sceme for custom options + incorperate globals

  flatpack.enable = true;
  borg.enable = true;
  sops.enable = true;

  # TODO: here
  # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  #   programs.coolercontrol.enable = true;

  # TODO: here
  # services = {
  #    power-profiles-daemon.enable = true;

  #   # battery info
  #   upower.enable = true;
  # };

  environment = {
    systemPackages = with pkgs; [nh];
    sessionVariables = {FLAKE = "/home/${globals.username}/.nixos/nixos";};
    pathsToLink = ["/share/zsh" "/share/xdg-desktop-portal" "/share/applications"]; # for zsh.enableCompletion
  };

  # hardware.keyboard.qmk.enable = true;
  # environment.systemPackages = with pkgs; [
  #   vial
  #   via
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

  programs.dconf.enable = true; # dconf -> edit system preferences
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
}
