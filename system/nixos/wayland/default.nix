{
  pkgs,
  globals,
  ...
}: {
  # TODO: here idk what most of this means
  programs = {
    hyprland = {
      enable = true;
      #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    xwayland.enable = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser brgenml1lpr brgenml1cupswrapper gutenprint gutenprintBin];
    };
    dbus.enable = true;
    gvfs.enable = true;

    # display Manager
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "${globals.username}";
        };
        default_session = initial_session;
      };
    };
  };

  # NOTE: maybe move this into hm?
  # TODO: here https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
  # portal for sharing (file pickers)
  xdg.portal = {
    enable = true;
    # TODO: here
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  #  xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal
  #   ];
  #   configPackages = [ pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal
  #   ];
  # };

  # systemd = {
  #   # Bind wlr-portal to systemd unit from home-manager
  #   user.services.xdg-desktop-portal-wlr = {
  #     partOf = ["graphical-session.target"];
  #     description = "wlroots desktop portal";
  #     unitConfig = {ConditionUser = "!@system";};
  #   };
  #   # Enable polkit for system wide auth, required as part of gnome-compat
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     partOf = ["graphical-session.target"];
  #     description = "Gnome polkit agent";
  #     script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     unitConfig = {ConditionUser = "!@system";};
  #   };
  #   extraConfig = "DefaultTimeoutStopSec=10s";
  # };
  # Security / Polkit
  # security = {
  #   rtkit.enable = true;
  #   polkit = {
  #     enable = true;
  #     extraConfig = ''
  #       polkit.addRule(function(action, subject) {
  #         if (
  #           subject.isInGroup("users")
  #             && (
  #               action.id == "org.freedesktop.login1.reboot" ||
  #               action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
  #               action.id == "org.freedesktop.login1.power-off" ||
  #               action.id == "org.freedesktop.login1.power-off-multiple-sessions"
  #             )
  #           )
  #         {
  #           return polkit.Result.YES;
  #         }
  #       })
  #     '';
  #   };

  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  #  security.pam.services.swaylock = {
  #   text = ''
  #     auth include login
  #   '';
  # };
  # environment.variables = {
  #   POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  # };

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  environment.systemPackages = with pkgs; [polkit_gnome];
}
