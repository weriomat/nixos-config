_: {
  # NOTE: kanshi is configured at the host level
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile = {
          name = "Setup";
          outputs = [
            {
              criteria = "Acer Technologies VG270U P 0x1071B314";
              status = "enable";
              mode = "2560x1440@144";
              position = "3840,0";
              scale = 1.0;
              transform = "270";
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 401NTZN3N389";
              position = "0,0";
              mode = "3840x2160@120.00";
              status = "enable";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
