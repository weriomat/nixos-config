{pkgs, ...}: {
  programs = {
    wireshark.enable = true;
    hyprland.enable = true;
    xwayland.enable = true;
  };
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser brgenml1lpr brgenml1cupswrapper gutenprint gutenprintBin];
    };
    dbus.enable = true;
    gvfs.enable = true;
  };

  # environment.variables = {
  #   POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  # };
  # sdl-videodriver = "x11"; # Either x11 or wayland ONLY. Games might require x11 set here
  # -> take a look at zaynes nixso conf
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

  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #     if (
  #       subject.isInGroup("users")
  #         && (
  #           action.id == "org.freedesktop.login1.reboot" ||
  #           action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
  #           action.id == "org.freedesktop.login1.power-off" ||
  #           action.id == "org.freedesktop.login1.power-off-multiple-sessions"
  #         )
  #       )
  #     {
  #       return polkit.Result.YES;
  #     }
  #   })
  # '';

  #  security.pam.services.swaylock = {
  #   text = ''
  #     auth include login
  #   '';
  # };

  # TODO: maybe move this into hm

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
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   xwayland.enable = true;
  # };

  # xdg.portal.config.common.default = "gtk";
  # Extra Portal Configuration
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal
  #   ];
  #   configPackages = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal
  #   ];
  # };

  # TODO: here https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
  # portal for sharing (file pickers)
  xdg.portal = {
    enable = true;
    # TODO: here
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  # TODO: here
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

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # environment.systemPackages = with pkgs; [polkit_gnome];
}
