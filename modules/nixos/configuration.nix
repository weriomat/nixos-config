{lib, ...}:
# TODO: swayidle setup in home-manager -> screen goes dark, movie watching do not disturbe https://gist.github.com/johanwiden/900723175c1717a72442f00b49b5060c
# TODO: gnome polkit
# TODO: gnome agendt ssh idk shit
# TODO: portals fix: -> script,
# TODO: improve hyprland config
# TODO: laptop power management
# TODO: brightnessctl
# TODO: waybar status -> corectl etc
# TODO: hyprland fix hyprland setup -> vimjoyer video
# TODO: cloudflare dns
{
  imports = [./user ./wayland ./common ./steam];

  audio.enable = true;
  doc.enable = true;
  graphical.enable = true;
  keyboard.enable = true;
  networking.enable = true;
  nix-settings.enable = true;
  packages.enable = true;
  virt.enable = true;
  # environment.variables = {
  #   POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  # };
  # sdl-videodriver = "x11"; # Either x11 or wayland ONLY. Games might require x11 set here
  # -> take a look at zaynes nixso conf
  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  # security.polkit.enable = true;

  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #     if (
  #       subject.isInGroup("users")
  #         && (
  #           action.id == "org.freedesktop.login1.reboot" ||
  #           action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
  #           action.id == "org.freedesktop.login1.power-off" ||
  #           action.id == "org.freedesktop.login1.power-off-multiple-sessions"
  #         )
  #       )
  #     {
  #       return polkit.Result.YES;
  #     }
  #   })
  # '';
  #  security.pam.services.swaylock = {
  #   text = ''
  #     auth include login
  #   '';
  # };
  #  xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal
  #   ];
  #   configPackages = [ pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal
  #   ];
  # };
  # programs.steam.gamescopeSession.enable = true;
  # programs.dconf.enable = true;
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   xwayland.enable = true;
  # };
  # polkit_gnome lm_sensors meson
  # OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };
  #   lib.mkIf (ntp == true) {
  #   networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  # }
  #  hardware.logitech.wireless.enable = true;
  # hardware.logitech.wireless.enableGraphical = true;
  #  services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "amdgpu" ];
  # services.xserver = {
  #   enable = true;
  #   xkb = {
  #     variant = "";
  #     layout = "${theKBDLayout}";
  #   };
  #   libinput.enable = true;
  #   displayManager.sddm = {
  #     enable = true;
  #     autoNumlock = true;
  #     wayland.enable = true;
  #     theme = "tokyo-night-sddm";
  #   };
  # };
  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  #   lib.mkIf ("${gpuType}" == "amd") {
  #   systemd.tmpfiles.rules = [
  #     "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #   ];
  #   services.xserver.enable = true;
  #   services.xserver.videoDrivers = [ "amdgpu" ];
  #   # OpenGL
  #   hardware.opengl = {
  #     ## amdvlk: an open-source Vulkan driver from AMD
  #     extraPackages = [ pkgs.amdvlk ];
  #     extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  #   };
  # }
  #   pkgs.writeShellScriptBin "emopicker9000" ''
  #     # Get user selection via wofi from emoji file.
  #     chosen=$(cat $HOME/.emoji | ${pkgs.rofi-wayland}/bin/rofi -dmenu | awk '{print $1}')

  #     # Exit if none chosen.
  #     [ -z "$chosen" ] && exit

  #     # If you run this command with an argument, it will automatically insert the
  #     # character. Otherwise, show a message that the emoji has been copied.
  #     if [ -n "$1" ]; then
  # 	    ${pkgs.ydotool}/bin/ydotool type "$chosen"
  #     else
  #         printf "$chosen" | ${pkgs.wl-clipboard}/bin/wl-copy
  # 	    ${pkgs.libnotify}/bin/notify-send "'$chosen' copied to clipboard." &
  #     fi
  # ''
  # home.file.".config/neofetch/config.conf".text = ''
  #       print_info() {
  #           info "$(color 6)  OS " distro
  #           info underline
  #           info "$(color 7)  VER" kernel
  #           info "$(color 2)  UP " uptime
  #           info "$(color 4)  PKG" packages
  #           info "$(color 6)  DE " de
  #           info "$(color 5)  TER" term
  #           info "$(color 3)  CPU" cpu
  #           info "$(color 7)  GPU" gpu
  #           info "$(color 5)  MEM" memory
  #           prin " "
  #           prin "$(color 1) $(color 2) $(color 3) $(color 4) $(color 5) $(color 6) $(color 7) $(color 8)"
  #       }
  #       distro_shorthand="on"
  #       memory_unit="gib"
  #       cpu_temp="C"
  #       separator=" $(color 4)>"
  #       stdout="off"
  #   '';

  # ssd thingie
  services.fstrim.enable = lib.mkDefault true;

  flatpack.enable = true;
  system.stateVersion = "23.11";
}
# exec-once = "xwaylandvideobridge"
#  pkgs, config, lib, ... }:
# let
#   palette = config.colorScheme.palette;
#   inherit (import ../../options.nix) slickbar simplebar clock24h;
# in with lib; {
#   # Configure & Theme Waybar
#   programs.waybar = {
#     enable = true;
#     package = pkgs.waybar;
#     settings = [{
#       layer = "top";
#       position = "top";
#       modules-center = if simplebar == true then [ "hyprland/window" ]
#       else [ "network" "pulseaudio" "cpu" "hyprland/workspaces" "memory" "disk" "clock" ];
#       modules-left = if simplebar == true then ["custom/startmenu" "hyprland/workspaces" "cpu" "memory" "network"  ]
#       else [ "custom/startmenu" "hyprland/window" ];
#       modules-right = if simplebar == true then [ "idle_inhibitor" "custom/themeselector" "custom/notification" "pulseaudio" "clock"  "tray" ]
#       else [ "idle_inhibitor" "custom/themeselector" "custom/notification" "battery" "tray" ];
#       "hyprland/workspaces" = {
#       	format = if simplebar == true then "{name}" else "{icon}";
#       	format-icons = {
#           default = " ";
#           active = " ";
#           urgent = " ";
#       	};
#       	on-scroll-up = "hyprctl dispatch workspace e+1";
#       	on-scroll-down = "hyprctl dispatch workspace e-1";
#       };
#       "clock" = {
# 	format = if clock24h == true then ''{: %H:%M}''
# 	else ''{: %I:%M %p}'';
#       	tooltip = true;
# 	tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
#       };
#       "hyprland/window" = {
#       	max-length = 25;
#       	separate-outputs = false;
#       };
#       "memory" = {
#       	interval = 5;
#       	format = " {}%";
#         tooltip = true;
#       };
#       "cpu" = {
#       	interval = 5;
#       	format = " {usage:2}%";
#         tooltip = true;
#       };
#       "disk" = {
#         format = " {free}";
#         tooltip = true;
#       };
#       "network" = {
#         format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
#         format-ethernet = " {bandwidthDownOctets}";
#         format-wifi = "{icon} {signalStrength}%";
#         format-disconnected = "󰤮";
#         tooltip = false;
#       };
#       "tray" = {
#         spacing = 12;
#       };
#       "pulseaudio" = {
#         format = "{icon} {volume}% {format_source}";
#         format-bluetooth = "{volume}% {icon} {format_source}";
#         format-bluetooth-muted = " {icon} {format_source}";
#         format-muted = " {format_source}";
#         format-source = " {volume}%";
#         format-source-muted = "";
#         format-icons = {
#           headphone = "";
#           hands-free = "";
#           headset = "";
#           phone = "";
#           portable = "";
#           car = "";
#           default = ["" "" ""];
#         };
#         on-click = "pavucontrol";
#       };
#       "custom/themeselector" = {
#         tooltip = false;
#         format = "";
#         # exec = "theme-selector";
#         on-click = "sleep 0.1 && theme-selector";
#       };
#       "custom/startmenu" = {
#         tooltip = false;
#         format = " ";
#         # exec = "rofi -show drun";
#         on-click = "rofi-launcher";
#       };
#       "idle_inhibitor" = {
#         format = "{icon}";
#         format-icons = {
#             activated = " ";
#             deactivated = " ";
#         };
#         tooltip = "true";
#       };
#       "custom/notification" = {
#         tooltip = false;
#         format = "{icon} {}";
#         format-icons = {
#           notification = "<span foreground='red'><sup></sup></span>";
#           none = "";
#           dnd-notification = "<span foreground='red'><sup></sup></span>";
#           dnd-none = "";
#           inhibited-notification = "<span foreground='red'><sup></sup></span>";
#           inhibited-none = "";
#           dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
#           dnd-inhibited-none = "";
#        	};
#         return-type = "json";
#         exec-if = "which swaync-client";
#         exec = "swaync-client -swb";
#         on-click = "task-waybar";
#         escape = true;
#       };
#       "battery" = {
#         states = {
#           warning = 30;
#           critical = 15;
#         };
#         format = "{icon} {capacity}%";
#         format-charging = "󰂄 {capacity}%";
#         format-plugged = "󱘖 {capacity}%";
#         format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
#         on-click = "";
#         tooltip = false;
#       };
#     }];
#     style = concatStrings [''
#       * {
# 	font-size: 16px;
# 	font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
#     	font-weight: bold;
#       }
#       window#waybar {
# 	${if slickbar == true then ''
# 	  background-color: rgba(26,27,38,0);
# 	  border-bottom: 1px solid rgba(26,27,38,0);
# 	  border-radius: 0px;
# 	  color: #${palette.base0F};
# 	'' else ''
# 	  background-color: #${palette.base00};
# 	  border-bottom: 1px solid #${palette.base00};
# 	  border-radius: 0px;
# 	  color: #${palette.base0F};
# 	''}
#       }
#       #workspaces {
# 	${if slickbar == true then ''
# 	  background: linear-gradient(180deg, #${palette.base00}, #${palette.base01});
# 	  margin: 5px;
# 	  padding: 0px 1px;
# 	  border-radius: 15px;
# 	  border: 0px;
# 	  font-style: normal;
# 	  color: #${palette.base00};
# 	'' else ''
# 	  background: linear-gradient(45deg, #${palette.base01}, #${palette.base01});
# 	  margin: 4px;
# 	  padding: 0px 1px;
# 	  border-radius: 10px;
# 	  border: 0px;
# 	  font-style: normal;
# 	  color: #${palette.base00};
# 	''}
#       }
#       #workspaces button {
# 	${if slickbar == true then ''
# 	  padding: 0px 5px;
# 	  margin: 4px 3px;
# 	  border-radius: 15px;
# 	  border: 0px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
# 	  opacity: 0.5;
# 	  transition: all 0.3s ease-in-out;
# 	'' else ''
# 	  padding: 0px 5px;
# 	  margin: 4px 3px;
# 	  border-radius: 10px;
# 	  border: 0px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base06}, #${palette.base0E});
# 	  opacity: 0.5;
# 	  transition: all 0.3s ease-in-out;
# 	''}
#       }
#       #workspaces button.active {
# 	${if slickbar == true then ''
# 	  padding: 0px 5px;
# 	  margin: 4px 3px;
# 	  border-radius: 15px;
# 	  border: 0px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
# 	  opacity: 1.0;
# 	  min-width: 40px;
# 	  transition: all 0.3s ease-in-out;
# 	'' else ''
# 	  padding: 0px 5px;
# 	  margin: 4px 3px;
# 	  border-radius: 10px;
# 	  border: 0px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base06}, #${palette.base0E});
# 	  opacity: 1.0;
# 	  min-width: 40px;
# 	  transition: all 0.3s ease-in-out;
# 	''}
#       }
#       #workspaces button:hover {
# 	${if slickbar == true then ''
# 	  border-radius: 15px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base0D}, #${palette.base0E});
# 	  opacity: 0.8;
# 	'' else ''
# 	  border-radius: 10px;
# 	  color: #${palette.base00};
# 	  background: linear-gradient(45deg, #${palette.base06}, #${palette.base0E});
# 	  opacity: 0.8;
# 	''}
#       }
#       tooltip {
# 	background: #${palette.base00};
# 	border: 1px solid #${palette.base0E};
# 	border-radius: 10px;
#       }
#       tooltip label {
# 	color: #${palette.base07};
#       }
#       #window {
# 	${if slickbar == true then ''
# 	  color: #${palette.base05};
# 	  background: #${palette.base00};
# 	  border-radius: 50px 15px 50px 15px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  color: #${palette.base05};
# 	  background: #${palette.base01};
# 	  border-radius: 10px;
# 	''}
#       }
#       #memory {
#    	color: #${palette.base0F};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #clock {
#     	color: #${palette.base0B};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #idle_inhibitor {
#     	color: #${palette.base0A};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 50px 15px 50px 15px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #cpu {
#     	color: #${palette.base07};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 50px 15px 50px 15px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #disk {
#     	color: #${palette.base03};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #battery {
#     	color: #${palette.base08};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #network {
#     	color: #${palette.base09};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 50px 15px 50px 15px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #tray {
#     	color: #${palette.base05};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 0px 0px 50px;
# 	  margin: 5px 0px 5px 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #pulseaudio {
#     	color: #${palette.base0D};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 50px 15px 50px 15px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #custom-notification {
#     	color: #${palette.base0C};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #custom-themeselector {
#     	color: #${palette.base0D};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #custom-startmenu {
#     	color: #${palette.base03};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 0px 15px 50px 0px;
# 	  margin: 5px 5px 5px 0px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       }
#       #idle_inhibitor {
#     	color: #${palette.base09};
# 	${if slickbar == true then ''
# 	  background: #${palette.base00};
# 	  border-radius: 15px 50px 15px 50px;
# 	  margin: 5px;
# 	  padding: 2px 20px;
# 	'' else ''
# 	  background: #${palette.base01};
# 	  margin: 4px;
# 	  padding: 2px 10px;
# 	  border-radius: 10px;
# 	''}
#       } ''
#     ];
#   };
# }

