{
  inputs,
  globals,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.thunderbird.enable = mkEnableOption "Enable Thunderbird";

  config = mkIf config.thunderbird.enable {
    catppuccin.thunderbird = {
      enable = true;
      profile = globals.username;
    };

    programs.thunderbird = {
      enable = true;

      profiles = {
        ${globals.username} = {
          extraConfig = ""; # add to user.js
          settings = { }; # same ass extra config
          isDefault = true;
          userChrome = ""; # add to user crome css
          userContent = "";
          withExternalGnupg = true;
          extensions =
            with inputs.thunderbird-addons.legacyPackages.${pkgs.stdenv.hostPlatform.system}.thunderbird-addons; [
              (grammar-and-spell-checker.overrideAttrs { meta.license = licenses.free; })
            ];
        };
      };
      settings = { };
    };
  };
}
