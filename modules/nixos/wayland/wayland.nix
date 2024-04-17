{
  pkgs,
  globals,
  ...
}: {
  programs = {
    wireshark.enable = true;
    hyprland.enable = true;
    xwayland.enable = true;
  };
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser brgenml1lpr brgenml1cupswrapper gutenprint gutenprintBin];
      clientConf =
        if globals.isWork
        then "ServerName print.zib.de"
        else "";
    };
    dbus.enable = true;
    gvfs.enable = true;
  };

  # TODO: here https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
  # portal for sharing (file pickers)
  xdg.portal = {
    enable = true;
    # TODO: here
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  systemd = {
    # Bind wlr-portal to systemd unit from home-manager
    user.services.xdg-desktop-portal-wlr = {
      partOf = ["graphical-session.target"];
      description = "wlroots desktop portal";
      unitConfig = {ConditionUser = "!@system";};
    };
    # Enable polkit for system wide auth, required as part of gnome-compat
    user.services.polkit-gnome-authentication-agent-1 = {
      partOf = ["graphical-session.target"];
      description = "Gnome polkit agent";
      script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      unitConfig = {ConditionUser = "!@system";};
    };
    extraConfig = "DefaultTimeoutStopSec=10s";
  };

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  environment.systemPackages = with pkgs; [polkit_gnome];
}
