{
  pkgs,
  lib,
  ...
}: {
  options.waybar = {
    enable = lib.mkOption {
      type = lib.type.bool;
      default = false;
      description = "Enable waybar config";
    };
  };
  config = {
    programs.waybar = {enable = true;};
    programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
  };
}
