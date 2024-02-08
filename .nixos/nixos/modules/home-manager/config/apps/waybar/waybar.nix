{
  pkgs,
  lib,
  config,
  ...
}: {
  options.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable waybar config";
    };
  };
  config = lib.mkIf (config.waybar.enable) {
    programs.waybar = {enable = true;};
    programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
  };
}
