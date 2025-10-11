{
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
in
{
  options.discord = {
    enable = mkEnableOption "Enable discord overlay";
    executable = mkOption {
      description = "Executable of the discord";
      type = types.enum [
        "vesktop"
        "discord"
      ];
      default = "vesktop";
    };
  };

  config = mkIf config.discord.enable {
    catppuccin.vesktop.enable = true;

    programs = {
      zsh.shellAliases.discord = "vesktop";
      vesktop = {
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
  };
}
