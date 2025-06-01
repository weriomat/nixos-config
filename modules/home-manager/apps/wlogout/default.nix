# stolen from https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/wlogout/style.css?ref_type=heads
{
  pkgs,
  config,
  lib,
  globals,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    mkOption
    types
    ;
  wlo = config.programs.wlogout;
  cfg = config.wlogout;
in
{
  options.wlogout = {
    enable = mkEnableOption "Enable wlogout";
    font = mkOption {
      description = "Font to use for wlogout";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = [
      (
        "$mainMod, Q, exec, ${getExe wlo.package}"
        + lib.strings.optionalString (wlo.package == pkgs.wleave) " -p layer-shell"
      )
    ];

    programs.wlogout = {
      enable = true;
      package = pkgs.wleave;
      layout = [
        {
          label = "lock";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "loginctl"} lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "systemctl"} hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "loginctl"} terminate-user $USER";
          text = "Exit";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "systemctl"} poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "systemctl"} suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "${pkgs.coreutils}/bin/sleep 0.25; ${getExe' globals.systemd "systemctl"} reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
    catppuccin.wlogout = {
      enable = true;
      flavor = "mocha";
      # TODO: fix these png with the one from wleave
      extraStyle = # css
        ''
          * {
            font-family: ${cfg.font};
          	transition: 20ms;
          }

          #lock {
          	margin: 10px;
          	border-radius: 20px;
            /* background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); */
          }

          #logout {
          	margin: 10px;
          	border-radius: 20px;
            /*background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));*/
          }

          #suspend {
          	margin: 10px;
          	border-radius: 20px;
            /*background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));*/
          }

          #hibernate {
          	margin: 10px;
          	border-radius: 20px;
            /*background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));*/
          }

          #shutdown {
          	margin: 10px;
          	border-radius: 20px;
            /*background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));*/
          }

          #reboot {
          	margin: 10px;
          	border-radius: 20px;
            /*background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));*/
          }
        '';
    };
  };
}
