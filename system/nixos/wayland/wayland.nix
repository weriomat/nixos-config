{pkgs, ...}: {
  # TODO: here idk what most of this means
  programs = {
    hyprland.enable = true;
    xwayland.enable = true;
  };
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   xwayland.enable = true;
  # };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser brgenml1lpr brgenml1cupswrapper gutenprint gutenprintBin];
    };
    dbus.enable = true;
    gvfs.enable = true;
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

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  environment.systemPackages = with pkgs; [polkit_gnome];
}
