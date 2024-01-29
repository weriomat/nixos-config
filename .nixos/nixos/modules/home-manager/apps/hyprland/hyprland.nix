{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    # swayidle
    swayidle

    mpv-unwrapped
    playerctl
    pamixer
    networkmanagerapplet
    udiskie
    # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
    xwaylandvideobridge
    # swww
    swaybg
    # hyprpaper
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    # hyprpicker
    wofi
    grim
    slurp
    wl-clipboard
    # cliphist
    wf-recorder
    glib
    wayland
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
  # Allow for Hyprland start when tty1 is used, this is a fallback in case the DM fails
  programs.zsh.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec Hyprland
    fi
  '';
}
