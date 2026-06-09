{
  inputs,
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
    # Window manager only sessions (unlike DEs) don't handle XDG
    # autostart files, so force them to run the service
    xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;

    printing = {
      enable = true;
      drivers = [ ];
    };

    dbus = {
      enable = true;
      implementation = "broker";
    };
    gvfs.enable = true;

    # display Manager
    greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session =
          let
            # keep in sync with home-manager package
            hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            session = "${getExe' hyprland "start-hyprland"}";
            tuigreet = "${getExe pkgs.tuigreet}";
          in
          {
            command = "${tuigreet} --time --time-format '%I:%M %p | %a • %h | %F' --remember --power-shutdown '${getExe' config.systemd.package "systemctl"} poweroff' --power-reboot '${getExe' config.systemd.package "systemctl"} reboot' --cmd ${session}";
            user = "greeter";
          };
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
      # Without these boot logs will spam on screen
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
