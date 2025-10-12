_: {
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"

    # Bitwarden extension
    "float, title:^(.*Bitwarden Password Manager.*)$"

    # throw sharing indicators away
    "workspace special silent, title:^(Firefox — Sharing Indicator)$"
    "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

    # idle inhibit while watching videos
    "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
    "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
    "idleinhibit fullscreen, class:^(firefox)$"

    # "dimaround, class:^(gcr-prompter)$"
    # "dimaround, class:^(xdg-desktop-portal-gtk)$"
    # "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

    # fix xwayland apps
    "rounding 0, xwayland:1"
    "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
    "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

    # pinentry
    "stayfocused, class:^(Pinentry).*"
    "dimaround, class:^(Pinentry).*"
    "center, class:^(Pinentry).*"

    # hyprland share picker
    "float, title:MainPicker"
    "stayfocused, title:MainPicker"
    "dimaround, title:MainPicker"
    "center, title:MainPicker"
  ];

  #   # windowrule
  #   windowrule = pin,wofi
  #   windowrule = float,wofi
  #   windowrule = noborder,wofi
  #   windowrule = tile, neovide
  #   windowrule = idleinhibit focus,mpv
  #   windowrule = float,udiskie
  #   windowrulev2 = float, title:^(Picture-in-Picture)$
  #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$
  #   # windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*YouTube.*)$
  #   windowrulev2 = pin, title:^(Picture-in-Picture)$
  #   windowrule = float,imv
  #   windowrule = center,imv
  #   windowrule = size 1200 725,imv
  #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*imv.*)$
  #   windowrule = float,mpv
  #   windowrule = center,mpv
  #   windowrulev2 = opacity 1.0 override 1.0 override, title:^(.*mpv.*)$
  #   windowrule = tile,Aseprite
  #   windowrulev2 = opacity 1.0 override 1.0 override, class:(Aseprite)
  #   windowrulev2 = opacity 1.0 override 1.0 override, class:(Unity)
  #   windowrule = size 1200 725,mpv
  #   windowrulev2 = idleinhibit focus, class:^(mpv)$

  #   windowrule = float,title:^(float_kitty)$
  #   windowrule = center,title:^(float_kitty)$
  #   windowrule = size 950 600,title:^(float_kitty)$

  #   windowrulev2 = float,class:^(file_progress)$
  #   windowrulev2 = float,class:^(confirm)$
  #   windowrulev2 = float,class:^(dialog)$
  #   windowrulev2 = float,class:^(download)$
  #   windowrulev2 = float,class:^(notification)$
  #   windowrulev2 = float,class:^(error)$
  #   windowrulev2 = float,class:^(confirmreset)$
  #   windowrulev2 = float,title:^(Open File)$
  #   windowrulev2 = float,title:^(branchdialog)$
  #   windowrulev2 = float,title:^(Confirm to replace files)$
  #   windowrulev2 = float,title:^(File Operation Progress)$
  #
  #   # Example windowrule v1
  #   # windowrule = float, ^(kitty)$
  #   # Example windowrule v2
  #   # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
  #   # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
}
