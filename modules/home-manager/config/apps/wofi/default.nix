{
  lib,
  config,
  ...
}: {
  options.wofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wofi";
    };
  };
  config = lib.mkIf (config.wofi.enable) {
    # https://github.com/prtce/wofi
    xdg.configFile."wofi".source = ./config;
  };
}
