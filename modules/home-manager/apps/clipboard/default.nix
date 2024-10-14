{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.clipboard.enable = mkEnableOption "Enable Clipboard config with hyprland bindings";

  config = mkIf config.clipboard.enable {
    # NOTE: for wl-copy, wl-paste
    home.packages = [pkgs.wl-clipboard];

    # NOTE: clipboard history; `cliphist whipe` -> clear entire history
    services.cliphist = {
      enable = true;
      allowImages = true;
      systemdTarget = "hyprland-session.target";
      extraOptions = ["-max-items" "1000"];
    };

    programs = {
      zsh.shellAliases.fhc = "fh | ${pkgs.wl-clipboard}/bin/wl-copy";
      fzf.defaultOptions = [
        "--bind 'ctrl-y:execute-silent(${pkgs.toybox}/bin/printf {} | ${pkgs.toybox}/bin/cut -f 2- | ${pkgs.wl-clipboard}/bin/wl-copy --trim-newline)'"
      ];
    };

    # $mainMod + o -> search through history and select item to copy
    # $mainMod + Shift + o -> search through history and delete selected item from it
    wayland.windowManager.hyprland.settings.bind = let
      hist-copy = pkgs.writeShellScriptBin "hist-copy" ''
        ${config.services.cliphist.package}/bin/cliphist list | ${config.programs.wofi.package}/bin/wofi --dmenu --prompt "Copy Item" | ${config.services.cliphist.package}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
      '';
      hist-delete = pkgs.writeShellScriptBin "hist-delete" ''
        ${config.services.cliphist.package}/bin/cliphist list | ${config.programs.wofi.package}/bin/wofi --dmenu --prompt "Delete Item" | ${config.services.cliphist.package}/bin/cliphist delete
      '';
    in [
      "$mainMod, o, exec, ${hist-copy}/bin/hist-copy"
      "$mainMod SHIFT, o, exec, ${hist-delete}/bin/hist-delete"
    ];
  };
}
