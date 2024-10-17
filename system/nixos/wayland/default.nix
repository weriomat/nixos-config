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

  # TODO: here
  # greetd = {
  #    enable = true;
  #    settings = rec {
  #      regreet_session = {
  #        command = "${lib.exe pkgs.cage} -s -- ${lib.exe pkgs.greetd.regreet}";
  #        user = "greeter";
  #      };
  #      tuigreet_session =
  #        let
  #          session = "${pkgs.hyprland}/bin/Hyprland";
  #          tuigreet = "${lib.exe pkgs.greetd.tuigreet}";
  #        in
  #        {
  #          command = "${tuigreet} --time --remember --cmd ${session}";
  #          user = "greeter";
  #        };
  #      default_session = tuigreet_session;
  #    };
  #  };

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
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Enable polkit
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # Enable polkit for system wide auth, required as part of gnome-compat
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "Gnome polkit agent";
    partOf = ["graphical-session.target"];
    script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    unitConfig = {ConditionUser = "!@system";};
  };
  environment.systemPackages = with pkgs; [polkit_gnome];
}
