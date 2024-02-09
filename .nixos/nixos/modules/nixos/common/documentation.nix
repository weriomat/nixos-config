{
  lib,
  config,
  ...
}: {
  options.doc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable documentation settings";
    };
  };
  config = lib.mkIf (config.doc.enable) {
    documentation = {
      enable = true;
      man.enable = true;
      dev.enable = true;
      doc.enable = true;
      nixos.enable = true;
      info.enable = true;
    };
    services.hoogle.enable = true;
  };
}
