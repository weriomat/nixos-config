{...}: {
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    # height= 15;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "custom/playerctl#backward"
      "custom/playerctl#play"
      "custom/playerctl#foward"
    ];
    modules-center = ["hyprland/workspaces"];
    modules-right = ["tray" "cpu" "memory" "disk" "pulseaudio" "network" "clock"];
    clock = {
      format = " {:%H:%M}";
      tooltip = "true";
      tooltip-format = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
      format-alt = " {:%d/%m}";
    };

    # TODO: here
    "hyprland/workspaces" = {
      active-only = false;
      all-outputs = false;
      disable-scroll = false;
      on-scroll-up = "hyprctl dispatch workspace e-1";
      on-scroll-down = "hyprctl dispatch workspace e+1";
      format = "{name}";
      on-click = "activate";
      format-icons = {
        urgent = "";
        active = "";
        default = "";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "*" = 5;
        # "DP-1" = [ 1 ];
        # "DP-3" = [ 6 ];
        # "HDMI-A-1" = [ 11 ];
      };
    };
    # "wlr/workspaces" = {
    #   # active-only = false;
    #   # all-outputs = false;
    #   # disable-scroll = false;
    #   # on-scroll-up = "hyprctl dispatch workspace e-1";
    #   # on-scroll-down = "hyprctl dispatch workspace e+1";
    #   # format = "{name}";
    #   # on-click = "activate";
    #   # format-icons = {
    #   #   urgent = "";
    #   #   active = "";
    #   #   default = "";
    #   #   sort-by-number = true;
    #   # };
    #   persistent-workspaces = {

    #     "1" = [ "DP-1" ];
    #     "2" = [ "DP-1" ];
    #     "3" = [ "DP-1" ];
    #     "4" = [ "DP-1" ];
    #     "5" = [ "DP-1" ];
    #     #   "6" = [ "DP-3" ];
    #     #   "7" = [ "DP-3" ];
    #     #   "8" = [ "DP-3" ];
    #     #   "9" = [ "DP-3" ];
    #     #   "10" = [ "HDMI-A-1" ];
    #     #   "11" = [ "HDMI-A-1" ];
    #     #   "12" = [ "HDMI-A-1" ];
    #     #   "13" = [ "HDMI-A-1" ];
    #     #   "14" = [ "HDMI-A-1" ];
    #     #   "15" = [ "HDMI-A-1" ];
    #   };
    # };
    "custom/playerctl#backward" = {
      format = "󰙣 ";
      on-click = "playerctl previous";
      on-scroll-up = "playerctl volume .05+";
      on-scroll-down = "playerctl volume .05-";
    };
    "custom/playerctl#play" = {
      format = "{icon}";
      return-type = "json";
      exec = ''
        playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
      on-click = "playerctl play-pause";
      on-scroll-up = "playerctl volume .05+";
      on-scroll-down = "playerctl volume .05-";
      format-icons = {
        Playing = "<span>󰏥 </span>";
        Paused = "<span> </span>";
        Stopped = "<span> </span>";
      };
    };
    "custom/playerctl#foward" = {
      format = "󰙡 ";
      on-click = "playerctl next";
      on-scroll-up = "playerctl volume .05+";
      on-scroll-down = "playerctl volume .05-";
    };
    memory = {
      format = "󰟜 {}%";
      format-alt = "󰟜 {used} GiB"; # 
      interval = 2;
    };
    cpu = {
      format = "  {usage}%";
      format-alt = "  {avg_frequency} GHz";
      interval = 2;
    };
    disk = {
      # path = "/";
      format = "󰋊 {percentage_used}%";
      interval = 60;
    };
    network = {
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰀂 ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
      on-click = "nm-connection-editor";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁 ";
      format-icons = {default = [" "];};
      scroll-step = 5;
      on-click = "pamixer -t";
    };
    "custom/launcher" = {
      format = "";
      on-click = "pkill wofi || wofi --show drun";
      on-click-right = "pkill wofi || wallpaper-picker";
      tooltip = "false";
    };
  };
}
