{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.clipboard.enable = mkEnableOption "Enable Clipboard config with hyprland bindings";

  config = mkIf config.clipboard.enable {
    # NOTE: clipboard history; `cliphist whipe` -> clear entire history
    services.cliphist = {
      enable = true;
      allowImages = true;
      systemdTarget = "hyprland-session.target";
      extraOptions = ["-max-items" "1000"];
    };
  };
}
