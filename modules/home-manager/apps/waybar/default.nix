{
  globals,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    getExe
    getExe'
    ;
in
{
  options.waybar = {
    enable = mkEnableOption "Enable waybar config";
    font = mkOption { type = types.str; };
    background = mkOption {
      type = types.str;
      default = "#11111B";
    };
    opacity = mkOption {
      type = types.str;
      default = ".98";
    };
    primary_accent = mkOption {
      type = types.str;
      default = "@mauve"; # cba6f7
    };
    secondary_accent = mkOption {
      type = types.str;
      default = "@blue"; # 89b4fa
    };
    tertiary_accent = mkOption {
      type = types.str;
      default = "@text"; # cdd6f4
    };
    lavender_accent = mkOption {
      type = types.str;
      default = "@lavender"; # b4befe
    };
    tertiary_background_hex = mkOption {
      type = types.str;
      default = "#25253a";
    };
  };

  config = mkIf config.waybar.enable {
    # kill waybar
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod SHIFT, B, exec, ${getExe' pkgs.toybox "pkill"} -SIGUSR1 .waybar-wrapped"
    ];

    services.usbguard-dbus.enable = true;

    catppuccin.waybar = {
      enable = true;
      flavor = "mocha";
    };

    programs.waybar = {
      enable = true;

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
          "custom/yubikey"
          "cpu"
        ]
        ++ lib.optional globals.laptop "battery"
        ++ [
          "memory"
          "disk"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "pulseaudio#microphone"
          "custom/usbguard"
          "network"
          "clock"
        ];

        clock = {
          format = " {:%H:%M}";
          tooltip = "true";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = " {:%d/%m}";
        };

        "custom/yubikey" = {
          exec = getExe pkgs.waybar-yubikey;
          return-type = "json";
        };

        # from: https://github.com/max-baz/dotfiles/blob/77d345632ff6b5970612147db71da64361a6df3e/modules/linux/waybar.nix
        "custom/usbguard" = {
          format = "  {text}";
          exec = getExe pkgs.waybar-usbguard-wrapped + " -listen";
          return-type = "json";
          on-click = getExe pkgs.waybar-usbguard-wrapped + " -accept";
          on-click-right = getExe pkgs.waybar-usbguard-wrapped + " -reject";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          interval = 30; # set interval to check every 30sek instead of 1min
          tooltip-format = "{}\nClick to reload Waybar";
          on-click = "${getExe' globals.systemd "systemdctl"} restart --user waybar";
          format = ''<span color="#fab387">{icon}</span> {capacity}%'';
          format-charging = ''<span color="#a6e3a1">{icon}</span> {capacity}%'';
          format-warning = ''<span color="#a6e3a1"></span> {capacity}%'';
          format-full = "Charged ";
          format-plugged = "󱘖 {capacity}%";
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
        };

        # stolen from https://github.com/ErikReider/SwayAudioIdleInhibit
        "custom/audio_idle_inhibitor" = {
          format = "{icon}";
          exec = "${getExe pkgs.sway-audio-idle-inhibit} --dry-print-both-waybar";
          exec-if = "${getExe' pkgs.toybox "which"} sway-audio-idle-inhibit";
          return-type = "json";
          tooltip = true;
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
          on-scroll-up = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch workspace e-1";
          on-scroll-down = "${getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch workspace e+1";
          format = "{name}";
          on-click = "activate";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
            sort-by-number = true;
          };
          persistent-workspaces."*" = 5;
        };

        "custom/playerctl#backward" = {
          format = "󰙣 ";
          on-click = "${getExe pkgs.playerctl} previous";
          on-scroll-up = "${getExe pkgs.playerctl} volume .05+";
          on-scroll-down = "${getExe pkgs.playerctl} volume .05-";
        };
        "custom/playerctl#play" = {
          format = "{icon}";
          return-type = "json";
          exec = ''
            ${getExe pkgs.playerctl} -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F
          '';
          on-click = "${getExe pkgs.playerctl} play-pause";
          on-scroll-up = "${getExe pkgs.playerctl} volume .05+";
          on-scroll-down = "${getExe pkgs.playerctl} volume .05-";
          format-icons = {
            Playing = "<span>󰏥 </span>";
            Paused = "<span> </span>";
            Stopped = "<span> </span>";
          };
        };
        "custom/playerctl#forward" = {
          format = "󰙡 ";
          on-click = "${getExe pkgs.playerctl} next";
          on-scroll-up = "${getExe pkgs.playerctl} volume .05+";
          on-scroll-down = "${getExe pkgs.playerctl} volume .05-";
        };

        memory = {
          format = "󰟜 {}%";
          format-alt = "󰟜 {used} GiB"; # 
          interval = 2;
          tooltip = true;
          tooltip-format = "󰟜 {used:0.1f}GB/{total:0.1f}GB";
        };

        cpu = {
          format = "  {usage}%";
          format-alt = "  {avg_frequency} GHz";
          interval = 2;
        };

        disk = {
          path = if globals.laptop then "/home" else "/";
          format = "󰋊 {percentage_used}%";
          interval = 60;
          tooltip = true;
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰀂 ";
          tooltip-format = "{ifname} ({ipaddr}) via {gwaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 ";
          on-click = "${getExe' pkgs.util-linux "rfkill"} block wlan && ${getExe' pkgs.util-linux "rfkill"} unblock wlan";
          max-length = 30;
          interval = 5;
        };

        tray = {
          icon-size = 20;
          spacing = 8;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";

          format-icons.default = [ " " ];

          scroll-step = 5;

          on-click = "${getExe pkgs.pavucontrol} -t 3";
          # these do the same thing, as muscle memory
          on-click-middle = "${getExe pkgs.pamixer} -t";
          on-click-right = "${getExe pkgs.pamixer} -t";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";

          scroll-step = 5;
          on-scroll-down = "${getExe pkgs.pamixer} --default-source -d 5";
          on-scroll-up = "${getExe pkgs.pamixer} --default-source -i 5";

          on-click = "${getExe pkgs.pavucontrol} -t 4";
          # these do the same thing, as muscle memory
          on-click-middle = "${getExe pkgs.pamixer} --default-source -t";
          on-click-right = "${getExe pkgs.pamixer} --default-source -t";
        };

        "custom/launcher" = {
          format = "";
          on-click = "${getExe' pkgs.toybox "pkill"} wofi || ${getExe config.programs.wofi.package} --show drun";
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
            background: ${config.waybar.tertiary_background_hex};
            margin: 5px 5px;
            padding: 8px 12px;
            border-radius: 12px 12px 24px 24px;
            color: ${config.waybar.primary_accent};
        }
        #workspaces button {
            padding: 0px 5px;
            margin: 0px 3px;
            border-radius: 15px;
            color: ${config.waybar.background};
            background: ${config.waybar.secondary_accent};
            transition: all 0.2s ease-in-out;
        }

        #workspaces button.active {
            color: ${config.waybar.background};
            background-color: ${config.waybar.primary_accent};
            border-radius: 15px;
            min-width: 35px;
            background-size: 200% 200%;
            transition: all 0.2s ease-in-out;
        }

        #workspaces button:hover {
            color: ${config.waybar.background};
            background-color: ${config.waybar.lavender_accent};
            border-radius: 15px;
            min-width: 35px;
            background-size: 200% 200%;
        }

        #tray, #pulseaudio, #network, #battery, #cpu, #memory, #disk, #custom-audio_idle_inhibitor,
        #custom-yubikey, #custom-usbguard, #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward, #pulseaudio.microphone {
            background: ${config.waybar.tertiary_background_hex};
            font-weight: bold;
            margin: 5px 0px;
        }

        #battery {
            color:${config.waybar.tertiary_accent};
            border-radius: 0px 0 0px 0px;
            padding-left: 9px;
            padding-right: 9px;
        }

        #custom-usbguard, #pulseaudio.microphone {
            color:${config.waybar.tertiary_accent};
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
            color: ${config.waybar.tertiary_accent};
            border-radius: 10px 0px 0px 24px;
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }

        #memory {
            color: ${config.waybar.tertiary_accent};
            border-radius: 0px 0 0px 0px;
            padding-left: 9px;
            padding-right: 9px;
        }

        #disk {
            color: ${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #tray {
            color: ${config.waybar.tertiary_accent};
            border-radius: 10px 24px 10px 24px;
            padding: 0 20px;
            margin-left: 7px;
        }

        #pulseaudio {
            color: ${config.waybar.tertiary_accent};
            border-radius: 10px 0px 0px 24px;
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }
        #network {
            color: ${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #custom-audio_idle_inhibitor {
            color: ${config.waybar.tertiary_accent};
            border-radius: 0px 24px 10px 0px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #custom-yubikey {
            color: ${config.waybar.tertiary_accent};
            border-radius: 24px 10px 24px 10px;
            padding-left: 9px;
            padding-right: 15px;
        }

        #clock {
            color: ${config.waybar.tertiary_accent};
            background: ${config.waybar.tertiary_background_hex};
            border-radius: 0px 0px 0px 40px;
            padding: 10px 10px 15px 25px;
            margin-left: 7px;
            font-weight: bold;
            font-size: 16px;
        }
        #custom-launcher {
            color: ${config.waybar.secondary_accent};
            background: ${config.waybar.tertiary_background_hex};
            border-radius: 0px 0px 40px 0px;
            margin: 0px;
            padding: 0px 30px 0px 10px;
            font-size: 28px;
        }

        #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward {
            background: ${config.waybar.tertiary_background_hex};
            font-size: 22px;
        }
        #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.forward:hover{
            color: ${config.waybar.tertiary_accent};
        }
        #custom-playerctl.backward {
            color: ${config.waybar.primary_accent};
            border-radius: 24px 0px 0px 10px;
            padding-left: 12px;
            margin-left: 7px;
        }
        #custom-playerctl.play {
            color: ${config.waybar.secondary_accent};
            padding: 0 5px;
        }
        #custom-playerctl.forward {
            color: ${config.waybar.primary_accent};
            border-radius: 0px 10px 24px 0px;
            padding-right: 12px;
            margin-right: 7px
        }
        #window{
            background: ${config.waybar.tertiary_background_hex};
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
