{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.discord.enable = mkEnableOption "Enable discord overlay";

  config = mkIf config.discord.enable {
    catppuccin.vesktop.enable = true;
    programs.vesktop = {
      enable = true;
      vencord = {
        settings = {
          autoUpdate = false;
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
  };
}
