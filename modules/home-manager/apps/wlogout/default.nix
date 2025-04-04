# stolen from https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/wlogout/style.css?ref_type=heads
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
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
          # TODO: suspend
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${config.programs.hyprlock.package}/bin/hyprlock";
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
      style = mkForce ''
        * {
          font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        	background-image: none;
        	transition: 20ms;
        }

        window {
        	background-color: rgba(12, 12, 12, 0.1);
        }

        button {
        	color: #FFFFFF;
          font-size:20px;

          background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;

        	border-style: solid;
        	background-color: rgba(12, 12, 12, 0.3);
        	border: 3px solid #FFFFFF;

          box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        }

        button:focus,
        button:active,
        button:hover {
          color: #${config.colorScheme.palette.base06};
        	background-color: rgba(12, 12, 12, 0.5);
        	border: 3px solid #${config.colorScheme.palette.base06};
        }

        #lock {
        	margin: 10px;
        	border-radius: 20px;
        	background-image:  image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
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
