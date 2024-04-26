{
  pkgs,
  globals,
  ...
}: {
  # display manager
  services.greetd = {
    enable = true;
    # settings = {
    # default_session = {
    #   command =
    #     "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland -s Hyprland";
    #   user = "greeter";
    # };
    # };
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${globals.username}";
      };
      default_session = initial_session;
    };
  };
}
