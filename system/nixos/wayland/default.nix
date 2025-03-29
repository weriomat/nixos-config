{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce getExe getExe';
  # NOTE: this is the version used by home-manager
  # hyprland = config.home-manager.users.${globals.username}.wayland.windowManager.hyprland.finalPackage;
  inherit (pkgs) hyprland;
in
{
  imports = [ ./gnome.nix ];

  programs.xwayland.enable = true; # Enable simulation of x11

  hardware.graphics.enable = lib.mkDefault true;

  services = {
    # Window manager only sessions (unlike DEs) don't handle XDG
    # autostart files, so force them to run the service
    xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;

    printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
        pkgs.brgenml1lpr
        pkgs.brgenml1cupswrapper
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
    };

    dbus.enable = true;
    gvfs.enable = true;

    # display Manager
    greetd = {
      enable = true;
      settings.default_session =
        let
          session = "${getExe hyprland}";
          tuigreet = "${getExe pkgs.greetd.tuigreet}";
        in
        {
          command = "${tuigreet} --time --time-format '%I:%M %p | %a • %h | %F' --remember --power-shutdown '${getExe' pkgs.systemd "systemctl"} poweroff' --power-reboot '${getExe' pkgs.systemd "systemctl"} poweroff' --cmd ${session}";
          user = "greeter";
        };
    };
  };

  # TODO: here https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
  # portal for sharing (file pickers), gtk will be enabled by gnome
  xdg = {
    portal = {
      enable = true;
      wlr.enable = mkForce false; # hyprland has its own portal
      xdgOpenUsePortal = true;
      extraPortals = [
        (pkgs.xdg-desktop-portal-hyprland.override { inherit hyprland; })
      ];
      configPackages = [ hyprland ];
    };
    terminal-exec = {
      enable = true;
      settings.default = [
        "kitty.desktop"
      ];
    };
  };

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {
      # text = "auth include login";
    };
  };

  # Enable polkit for system wide auth, required as part of gnome-compat
  systemd.user = {
    services.polkit-gnome-authentication-agent-1 = {
      description = "Gnome polkit agent";
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      unitConfig = {
        ConditionUser = "!@system";
      };
    };

    # Set default hyprland environment
    extraConfig = ''
      DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
    '';
  };
  environment.systemPackages = [ pkgs.polkit_gnome ];
}
