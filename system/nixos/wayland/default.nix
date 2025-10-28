{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe getExe';
in
{
  imports = [ ./gnome.nix ];

  programs.xwayland.enable = true; # Enable simulation of x11

  hardware.graphics.enable = lib.mkDefault true;

  services = {
    displayManager.defaultSession = "hyprland";

    # Window manager only sessions (unlike DEs) don't handle XDG
    # autostart files, so force them to run the service
    xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;

    # TODO: ipp-usb (IPP protocol for usb printers)
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
          session = "${getExe pkgs.hyprland}";
          tuigreet = "${getExe pkgs.greetd.tuigreet}";
        in
        {
          command = "${tuigreet} --time --time-format '%I:%M %p | %a • %h | %F' --remember --power-shutdown '${getExe' config.systemd.package "systemctl"} poweroff' --power-reboot '${getExe' config.systemd.package "systemctl"} poweroff' --cmd ${session}";
          user = "greeter";
        };
    };
  };

  # from: https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/208dc6d96520c96136932e6b5a339b7112e3f2fb/nixos/display-manager.nix
  users.users.greeter = {
    isNormalUser = false;
    description = "greetd greeter user";
    extraGroups = [
      "video"
      "audio"
    ];
    linger = true;
  };

  # portals managed by hm
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  systemd = {
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    user = {
      # Enable polkit for system wide auth, required as part of gnome-compat
      services.polkit-gnome-authentication-agent-1 = {
        description = "Gnome polkit agent";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        unitConfig = {
          ConditionUser = "!@system";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
          Type = "simple";
        };
      };

      # Set default hyprland environment
      extraConfig = ''
        DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
      '';
    };
  };
  environment.systemPackages = [ pkgs.polkit_gnome ];
}
