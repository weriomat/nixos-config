{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  # TODO: fix this
  # imports = [ (import ./theme-template.nix) ];
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];
  options.discord.enable = mkEnableOption "Enable discord overlay";

  config = mkIf config.discord.enable {
    #   home.packages = [
    #     # vesktop
    #     # https://github.com/Goxore/nixconf/blob/main/homeManagerModules/features/vesktop.nix
    #     # TODO: catppucin, catppuccin-discord https://github.com/NixOS/nixpkgs/pull/365773/commits/db285865f73b3214f13536c32aa729bb4de77baa
    #     (pkgs.discord.override {
    #       withOpenASAR = true;
    #       withVencord = true;
    #     })
    #     # discord
    #   ];
    #
    # css for discord
    # programs.discocss = {
    #   enable = true;
    #   css = ''
    #     @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
    #   '';
    #   discordAlias = true; # alias discocss to discord
    #   discordPackage = pkgs.discord;
    # };
    # NOTE: install: enable all the plugins, add https://catppuccin.github.io/discord/dist/catppuccin-mocha-pink.theme.css as theme
    programs.nixcord = {
      enable = true;
      config = {
        useQuickCss = true;
        frameless = true;
        plugins = {
          messageLogger = {
            enable = true;
            collapseDeleted = true;
          };
          clearURLs.enable = true;
          memberCount.enable = true;
          showMeYourName.enable = true;
          fakeNitro.enable = true;
        };
      };
    };
  };
}
