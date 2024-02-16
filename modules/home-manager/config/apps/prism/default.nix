{
  lib,
  config,
  ...
}: {
  # options.my_prism = {
  #   enable = lib.mkOption {
  #     type = lib.types.bool;
  #     default = false;
  #     description = "Enable prism";
  #   };
  # };

  # config = lib.mkIf config.my_prism.enable {
  prism = {
    enable = true;
    wallpapers = ./wallpapers;
    outPath = ".nixos/nixos/wallpapers";
    colorscheme = config.colorScheme;
  };
  # };
}
