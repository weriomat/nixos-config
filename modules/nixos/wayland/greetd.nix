{
  pkgs,
  globals,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${globals.username}";
      };
      default_session = initial_session;
    };
  };
}
