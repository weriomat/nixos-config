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
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  options.discord.enable = mkEnableOption "Enable discord overlay";

  config = mkIf config.discord.enable {
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
