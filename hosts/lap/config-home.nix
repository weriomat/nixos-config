_: {
  # NOTE: kanshi is configured at the host level
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1200@60";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
      # {
      #   profile = {
      #     name = "new";
      #     outputs = [
      #       {
      #         # internal display
      #         criteria = "eDP-1";
      #         status = "enable";
      #         mode = "1920x1200@60";
      #         scale = 1.0;
      #       }
      #       {
      #         criteria = "LG Electronics LG ULTRAGEAR+";
      #         status = "enable";
      #         mode = "3840x2160@95";
      #       }
      #       {
      #         criteria = "Acer Technologies VG270U P 0x1071B314";
      #         status = "enable";
      #         # mode = "1920x1080@120"; # TODO: check if 1440p works
      #         scale = 1.0;
      #       }
      #     ];
      #   };
      # }
      {
        profile = {
          name = "two";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1200@60";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 401NTZN3N389";
              # criteria = "DP-5";
              position = "1920,0";
              status = "enable";
              scale = 1.0;
              mode = "3840x2160@95";
            }
          ];
        };
      }
      {
        profile = {
          name = "asdf";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1200@60";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Acer Technologies VG270U P 0x1071B314";
              # criteria = "DP-5";
              status = "enable";
              mode = "2560x1440@144";
              position = "5760,0";
              scale = 1.0;
              transform = "270";
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 401NTZN3N389";
              position = "1920,0";
              # mode = "3840x2160@95";
              # mode = "3840x2160@95.03";
              mode = "3840x2160@60";
              status = "enable";
              scale = 1.0;
            }
          ];
        };
      }
      # {
      #   profile = {
      #     name = "home_office";
      #     outputs = [
      #       {
      #         # internal display
      #         criteria = "eDP-1";
      #         status = "enable";
      #         mode = "1920x1200@60";
      #         scale = 1.0;
      #       }
      #       {
      #         criteria = "Lenovo Group Limited Y25-30 U3W0DYXB";
      #         status = "enable";
      #         mode = "1920x1080@240";
      #         scale = 1.0;
      #       }
      #       {
      #         criteria = "Acer Technologies VG270U P 0x1071B314";
      #         status = "enable";
      #         mode = "1920x1080@120"; # TODO: check if 1440p works
      #         scale = 1.0;
      #       }
      #     ];
      #   };
      # }
    ];
  };
}
