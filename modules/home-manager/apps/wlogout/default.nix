# stolen from https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/wlogout/style.css?ref_type=heads
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.wlogout.enable = mkEnableOption "Enable wlogout";

  config = mkIf config.wlogout.enable {
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, Q, exec, ${config.programs.wlogout.package}/bin/wlogout"
    ];

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/loginctl terminate-user $USER";
          text = "Exit";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${pkgs.systemd}/bin/systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
    catppuccin.wlogout = {
      enable = true;
      flavor = "mocha";
      extraStyle = ''
        * {
          font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        	transition: 20ms;
        }

        #lock {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
        }

        #logout {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
        }

        #suspend {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
        	margin: 10px;
        	border-radius: 20px;
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
      '';
    };
  };
}
