{
  lib,
  globals,
  ...
}:
{
  steam.enable = true;
  # TODO: here
  borg.enable = lib.mkForce false;
  sops.enable = lib.mkForce false;

  # NOTE: kanshi is configured at the host level
  home-manager.users.${globals.username} = {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      profiles = {
        normal = {
          outputs = [
            {
              criteria = "DP-1";
              status = "enable";
              mode = "1920x1080@240";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enabled";
              mode = "3840x2160@120";
              position = "1920,0";
              scale = 1.0;
            }
            {
              criteria = "DP-3";
              status = "enable";
              mode = "2560x1440@144";
              position = "5760,0";
              scale = 1.0;
            }
          ];
        };
      };
    };
  };
}
