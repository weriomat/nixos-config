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

    # $mainMod + o -> search through history and select item to copy
    # $mainMod + Shift + o -> search through history and delete selected item from it
    wayland.windowManager.hyprland.settings.bind = let
      hist-copy = pkgs.writeShellScriptBin "hist-copy" ''
        #!/usr/bin/env zsh
        cliphist list | wofi --dmenu --prompt "Copy Item" | cliphist decode | wl-copy
      '';
      hist-delete = pkgs.writeShellScriptBin "hist-delete" ''
        #!/usr/bin/env zsh
        cliphist list | wofi --dmenu --prompt "Delete Item" | cliphist delete
      '';
    in [
      "$mainMod, o, exec, ${hist-copy}/bin/hist-copy"
      "$mainMod SHIFT, o, exec, ${hist-delete}/bin/hist-delete"
    ];
  };
}
