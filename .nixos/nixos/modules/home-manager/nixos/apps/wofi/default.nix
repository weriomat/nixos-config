{lib, ...}: {
  options.wofi = {
    enable = lib.mkOption {
      type = lib.type.bool;
      default = false;
      description = "Enable wofi";
    };
  };
  config = {
    # https://github.com/prtce/wofi
    xdg.configFile."wofi".source = ./config;
  };
}
