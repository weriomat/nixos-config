{
  lib,
  config,
  globals,
  ...
}: let
  inherit (lib) mkOption types mkIf;
in {
  options.sops = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sops settings";
    };
  };

  config = mkIf config.sops.enable {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/home/${globals.username}/.config/sops/age/keys.txt";

      # TODO: passwd file + mutableusers
      secrets.borg-key = {
        owner = "${globals.username}";
      };
    };
  };
}
