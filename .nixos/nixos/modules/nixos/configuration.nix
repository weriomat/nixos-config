{ inputs, config, pkgs, ouputs, ... }:
# TODO: nixcolors
# TODO: make everthing a module
# TODO: swayidle setup in home-manager -> screen goes dark, movie watching do not disturbe https://gist.github.com/johanwiden/900723175c1717a72442f00b49b5060c
# TODO: wlogout
# TODO: gnome polkit
# TODO: gnome agendt ssh idk shit
# TODO: greetd config
# TODO: portals fix: -> script, 
# TODO: steam
# TODO: improve hyprland config
# TODO: laptop power management
# TODO: brightnessctl
# TODO: waybar status -> corectl etc
# TODO: fix discord links -> https://lemmy.ml/post/1557630
# TODO: hyprland fix hyprland setup -> vimjoyer video
# TODO: cloudflare dns
# TODO: cleanup 
# TODO: fix laptop setup

{
  imports =
    [ ./common/default.nix ./common/flatpak.nix ./user.nix ]; # ./wayland.nix ];

  programs = {
    wireshark.enable = true;
    hyprland.enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # TODO: here https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
  # portal for sharing (file pickers)
  xdg.portal = {
    enable = true;
    # TODO: here
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      #pkgs.xdg-desktop-portal-gtk 
    ];
  };

  # Bind wlr-portal to systemd unit from home-manager
  systemd.user.services.xdg-desktop-portal-wlr = {
    partOf = [ "graphical-session.target" ];
    description = "wlroots desktop portal";
    unitConfig = { ConditionUser = "!@system"; };
  };

  # Enable polkit
  # security.polkit.enable = true;

  # home.packages = with pkgs; [ polkit_gnome ];

  # Enable polkit for system wide autz, required as part of gnome-compat 
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   partOf = [ "graphical-session.target" ];
  #   description = "Gnome polkit agent";
  #   script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #   unitConfig = { ConditionUser = "!@system"; };
  # };

  # TODO: gnome -> hyperland
  services = {
    xserver = {
      # Enable the X11 windowing system.
      # enable = true;
      # Configure keymap in X11
      layout = "us";
      # xkbVariant = "";
      # videoDrivers = [ "amdgpu" ];
      displayManager.gdm = {
        # enable = true;
        enable = false;
        #   wayland = true;
      };
      displayManager.autoLogin = {
        enable = true;
        user = "marts";
      };
      displayManager.sddm.enable = false;
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;

      # trackpad
      # libinput = {
      #   enable = true;
      #   # mouse = { accelProfile = "flat"; };
      # };
    };

    # display manager
    greetd = {
      enable = true;
      # settings = {
      # default_session = {
      #   command =
      #     "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland -s Hyprland";
      #   user = "greeter";
      # };
      # };
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "marts";
        };
        default_session = initial_session;
      };
    };

    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
  security.pam.services.swaylock = { };

  # imports = [ ./common ./common/flatpak.nix ./user.nix ./wayland ];

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall =
  #     true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall =
  #     true; # Open ports in the firewall for Source Dedicated Server
  # };
  # system.stateVersion = "23.11";
}
