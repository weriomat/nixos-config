{
  lib,
  config,
  ...
}: {
  options.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable sops settings";
    };
  };
  config = lib.mkIf config.sops.enable {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/home/marts/.config/sops/age/keys.txt";

      secrets.borg-key = {
        owner = "marts";
      };
    };
  };
}
