{ lib, pkgs, ... }:
let
  inherit (lib) mkIf;
in
{
  # https://celluloid-player.github.io/
  home.packages = mkIf pkgs.stdenv.isLinux [ pkgs.celluloid ]; # gtk wrapper from gnome around mpv
  # TODO: https://github.com/Sly-Harvey/NixOS/blob/master/modules/programs/media/mpv/default.nix
  # https://kokomins.wordpress.com/2019/10/14/mpv-config-guide/
  # https://www.reddit.com/r/mpv/comments/16nlrjh/new_quality_profiles_have_been_added_to_mpv/
  # https://github.com/search?q=repo%3AFrost-Phoenix%2Fnixos-config%20imv&type=code
  # https://github.com/lpdkt/noise/blob/main/modules/home/programs/mpv.nix
  # https://github.com/niksingh710/ndots/blob/master/modules/home/nixos/mpv.nix
  # https://github.com/stax76/awesome-mpv
  # https://github.com/lpdkt/noise/blob/main/modules/home/programs/mpv.nix
  # TODO: Video viewer
  # programs.mpv = {
  #      enable = true;
  #      bindings = {
  #        l = "seek 20";
  #        h = "seek -20";
  #        "]" = "add speed 0.1";
  #        "[" = "add speed -0.1";
  #        j = "seek -4";
  #        k = "seek 4";
  #        K = "cycle sub";
  #        J = "cycle sub down";
  #        w = "add sub-pos -10"; # move subtitles up
  #        W = "add sub-pos -1"; # move subtitles up
  #        e = "add sub-pos +10"; # move subtitles down
  #        E = "add sub-pos +1"; # move subtitles down
  #        "=" = "add sub-scale +0.1";
  #        "-" = "add sub-scale -0.1";
  #      };

  #      config = {
  #        speed = 1;
  #        hwdec = true;
  #        sub-pos = 90;
  #        keep-open = true;
  #        sub-auto = "all";
  #        sub-font-size = 40;
  #        sub-border-size = 2;
  #        sub-shadow-offset = 2;
  #        sub-visibility = "yes";
  #        sub-ass-line-spacing = 1;
  #        sub-ass-hinting = "normal";
  #        sub-ass-override = "force";
  #        save-position-on-quit = true;
  #        sub-auto-exts = "srt,ass,txt";
  #        ytdl-format = "bestvideo+bestaudio/best";
  #        slang = "fin,fi,fi-fi,eng,en,en-en,en-orig";
  #        sub-font = "${config.stylix.fonts.serif.name}";
  #        sub-ass-force-style = "${config.stylix.fonts.serif.name}";
  #        sub-color = "${config.lib.stylix.colors.withHashtag.base07}";
  #        sub-shadow-color = "${config.lib.stylix.colors.withHashtag.base00}";
  #        watch-later-options-clr = true; # Dont save settings like brightness
  #      };
  #      scripts = [
  #        pkgs.mpvScripts.uosc
  #        pkgs.mpvScripts.acompressor
  #      ];
  #    };
  #
  # programs.mpv = {
  #   enable = true;
  #   config = {
  #     hwdec = "auto-safe";
  #     vo = "gpu";
  #     osc = "no";
  #     border = "no";
  #     profile = "gpu-hq";
  #     gpu-context = "wayland";
  #     force-window = true;
  #     ytdl-format = "bestvideo+bestaudio";
  #   };
  # };
  #
  #  programs.mpv = {
  #   enable = true;
  #   defaultProfiles = ["gpu-hq"];
  #   scripts = [pkgs.mpvScripts.mpris];
  # };
}
