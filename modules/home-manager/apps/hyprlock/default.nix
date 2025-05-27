{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.hyprlock;
in
{
  options.hyprlock = {
    enable = mkEnableOption "Enable hyprlock";
    font = mkOption {
      description = "Font to use for hyprlock";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    catppuccin.hyprlock = {
      enable = true;
      flavor = "mocha";
      useDefaultConfig = false;
    };

    # Stolen from https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/hyprland/hyprlock.nix
    # unlock hyprlock from other tty via `kill -USR1 hyprlock`
    programs.hyprlock = {
      enable = true;

      settings =
        {
          general = {
            hide_cursor = true;
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = false;
            ignore_empty_input = true;
            fractional_scaling = 0;
          };

          background = [
            {
              monitor = "";
              path = "${pkgs.weriomat-wallpapers}/wallpapers/deer-sunset.jpg";
              blur_passes = 2;
              contrast = 0.8916;
              brightness = 0.8172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            }
          ];
        }
        # FROM: https://github.com/catppuccin/hyprlock
        // {
          # source = $HOME/.config/hypr/mocha.conf

          # $accent = $mauve
          # $accentAlpha = $mauveAlpha
          "$font" = cfg.font;

          # GENERAL
          general = {
            hide_cursor = true;
          };

          # BACKGROUND
          background = {
            monitor = "";
            # path = $HOME/.config/background
            blur_passes = 0;
            color = "$base";
          };

          label = [
            # LAYOUT
            {
              monitor = "";
              text = "Layout: $LAYOUT";
              color = "$text";
              font_size = 25;
              font_family = "$font";
              position = "30, -30";
              halign = "left";
              valign = "top";
            }

            # TIME
            {
              monitor = "";
              text = "$TIME";
              color = "$text";
              font_size = "90";
              font_family = "$font";
              position = "-30, 0";
              halign = "right";
              valign = "top";
            }

            # DATE
            {
              monitor = "";
              text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
              color = "$text";
              font_size = "25";
              font_family = "$font";
              position = "-30, -150";
              halign = "right";
              valign = "top";
            }
          ];

          # # FINGERPRINT
          # {
          #   monitor = "";
          #   text = "$FPRINTPROMPT";
          #   color = "$text";
          #   font_size = 14;
          #   font_family = font;
          #   position = "0, -107";
          #   halign = "center";
          #   valign = "center";
          # }

          # USER AVATAR
          image = {
            monitor = "";
            path = "$HOME/.face";
            size = "100";
            border_color = "$accent";
            position = "0, 75";
            halign = "center";
            valign = "center";
          };

          # INPUT FIELD
          input-field = {
            font_family = "$font"; # added
            monitor = "";
            size = "300, 60";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "$accent";
            inner_color = "$surface0";
            font_color = "$text";
            fade_on_empty = false;
            placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
            hide_input = false;
            check_color = "$accent";
            fail_color = "$red";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = "$yellow";
            position = "0, -47";
            halign = "center";
            valign = "center";
          };
        };
    };
  };
}
