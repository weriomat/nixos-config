{
  inputs,
  pkgs,
  ...
}: {
  # programs = {
  #   hyprland.enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # };

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
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  # Bind wlr-portal to systemd unit from home-manager
  systemd.user.services.xdg-desktop-portal-wlr = {
    partOf = ["graphical-session.target"];
    description = "wlroots desktop portal";
    unitConfig = {ConditionUser = "!@system";};
  };

  # Enable polkit
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [polkit_gnome];

  # Enable polkit for system wide auth, required as part of gnome-compat
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    partOf = ["graphical-session.target"];
    description = "Gnome polkit agent";
    script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    unitConfig = {ConditionUser = "!@system";};
  };

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
  security.pam.services.swaylock = {};
}
