{
  lib,
  config,
  globals,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.sops.enable = mkEnableOption "Enable sops settings";

  config = mkIf config.sops.enable {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/keys.txt";

      # TODO: passwd file + mutableusers
      secrets.borg-key = {
        owner = "${globals.username}";
      };
    };
  };
}
