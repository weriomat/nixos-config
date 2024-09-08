{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
with lib; {
  options.waybar = {
    enable = mkEnableOption "Enable waybar config";
    font = mkOption {
      type = types.str;
      default = "JetBrainsMono Nerd Font";
    };
    background = mkOption {
      type = types.str;
      default = "11111B";
    };
    opacity = mkOption {
      type = types.str;
      default = ".98";
    };
    primary_accent = mkOption {
      type = types.str;
      default = "${config.colorScheme.palette.base0E}";
    };
    secondary_accent = mkOption {
      type = types.str;
      default = "${config.colorScheme.palette.base0D}";
    };
    tertiary_accent = mkOption {
      type = types.str;
      default = "${config.colorScheme.palette.base05}";
    };
    lavender_accent = mkOption {
      type = types.str;
      default = "${config.colorScheme.palette.base07}";
    };
    tertiary_background_hex = mkOption {
      type = types.str;
      default = "25253a";
    };
  };

  config = mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
      });

      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };

      settings.mainBar = {
        position = "top";
        layer = "top";
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [
          "custom/launcher"
          "custom/playerctl#backward"
          "custom/playerctl#play"
          "custom/playerctl#forward"
          "custom/audio_idle_inhibitor"
        ];
        modules-center = ["hyprland/workspaces"];
        modules-right =
          if globals.laptop
          then ["tray" "cpu" "battery" "memory" "disk" "pulseaudio" "network" "clock"]
          else ["tray" "cpu" "memory" "disk" "pulseaudio" "network" "clock"];
        clock = {
          format = " {:%H:%M}";
          tooltip = "true";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = " {:%d/%m}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = ''<span color="#fab387">{icon}</span> {capacity}%'';
          format-charging = ''<span color="#a6e3a1">{icon}/span> {capacity}%'';
          format-warning = ''<span color="#a6e3a1"></span> {capacity}%'';
          format-full = "Charged ";
          format-icons = {
            "charging" = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            "default" = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          # max-length = 25;
          tooltip = false;
        };

        # stolen from https://github.com/ErikReider/SwayAudioIdleInhibit
        "custom/audio_idle_inhibitor" = {
          format = "{icon}";
          exec = "sway-audio-idle-inhibit --dry-print-both-waybar";
          exec-if = "which sway-audio-idle-inhibit";
          return-type = "json";
          format-icons = {
            output = "";
            input = "";
            output-input = "  ";
            none = "";
          };
        };

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
          };
        };
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
        "custom/playerctl#forward" = {
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
          path =
            if globals.laptop
            then "/home"
            else "/";
          format = "󰋊 {percentage_used}%";
          interval = 60;
        };
        network = {
          format-wifi = "  {signalStrength}% <span color='#589df6'>⇵</span> {bandwidthUpBits}/{bandwidthDownBits}";
          format-ethernet = "󰀂  <span color='#589df6'>⇵</span> {bandwidthUpBits}/{bandwidthDownBits}";
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

      style = ''
        * {
            border: none;
            border-radius: 0px;
            font-family: ${config.waybar.font};
            font-weight: bold;
            font-size: 15px;
            min-height: 0;
            opacity: ${config.waybar.opacity};
        }

        window#waybar {
            background: none;
        }

        #workspaces {
            background: #${config.waybar.tertiary_background_hex};
            margin: 5px 5px;
            padding: 8px 12px;
            border-radius: 12px 12px 24px 24px;
            color: #${config.waybar.primary_accent};
        }
        #workspaces button {
            padding: 0px 5px;
            margin: 0px 3px;
            border-radius: 15px;
            color: #${config.waybar.background};
            background: #${config.waybar.secondary_accent};
            transition: all 0.2s ease-in-out;
        }

        #workspaces button.active {
            background-color: #${config.waybar.primary_accent};
            color: #${config.waybar.background};
            border-radius: 15px;
            min-width: 35px;
            background-size: 200% 200%;
            transition: all 0.2s ease-in-out;
        }

        #workspaces button:hover {
            background-color: #${config.waybar.lavender_accent};
            color: #${config.waybar.background};
            border-radius: 15px;
            min-width: 35px;
            background-size: 200% 200%;
        }

        #tray, #pulseaudio, #network, #battery, #cpu, #memory, #disk, #custom-audio_idle_inhibitor
        #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward{
            background: #${config.waybar.tertiary_background_hex};
            font-weight: bold;
            margin: 5px 0px;
        }

        #battery {
            color:#${config.waybar.tertiary_accent};
            border-radius: 0px 0 0px 0px;
            padding-left: 9px;
            padding-right: 9px;
        }

        #battery.critical:not(.charging) {
            animation-name: blink;
            animation-duration: 1s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #cpu {
            color: #${config.waybar.tertiary_accent};
            border-radius: 10px 0px 0px 24px;
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }
        #memory {
            color: #${config.waybar.tertiary_accent};
            border-radius: 0px 0 0px 0px;
            padding-left: 9px;
            padding-right: 9px;
        }
        #disk {
            color: #${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #tray {
            color: #${config.waybar.tertiary_accent};
            border-radius: 10px 24px 10px 24px;
            padding: 0 20px;
            margin-left: 7px;
        }

        #pulseaudio {
            color: #${config.waybar.tertiary_accent};
            border-radius: 10px 0px 0px 24px;
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }
        #network {
            color: #${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #custom-audio_idle_inhibitor{
            color: #${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #clock {
            color: #${config.waybar.tertiary_accent};
            background: #${config.waybar.tertiary_background_hex};
            border-radius: 0px 0px 0px 40px;
            padding: 10px 10px 15px 25px;
            margin-left: 7px;
            font-weight: bold;
            font-size: 16px;
        }
        #custom-launcher {
            color: #${config.waybar.secondary_accent};
            background: #${config.waybar.tertiary_background_hex};
            border-radius: 0px 0px 40px 0px;
            margin: 0px;
            padding: 0px 30px 0px 10px;
            font-size: 28px;
        }

        #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward {
            background: #${config.waybar.tertiary_background_hex};
            font-size: 22px;
        }
        #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.forward:hover{
            color: #${config.waybar.tertiary_accent};
        }
        #custom-playerctl.backward {
            color: #${config.waybar.primary_accent};
            border-radius: 24px 0px 0px 10px;
            padding-left: 16px;
            margin-left: 7px;
        }
        #custom-playerctl.play {
            color: #${config.waybar.secondary_accent};
            padding: 0 5px;
        }
        #custom-playerctl.forward {
            color: #${config.waybar.primary_accent};
            border-radius: 0px 10px 24px 0px;
            padding-right: 12px;
            margin-right: 7px
        }
        #window{
            background: #${config.waybar.tertiary_background_hex};
            padding-left: 15px;
            padding-right: 15px;
            border-radius: 16px;
            margin-top: 5px;
            margin-bottom: 5px;
            font-weight: normal;
            font-style: normal;
        }
      '';
    };
  };
}
