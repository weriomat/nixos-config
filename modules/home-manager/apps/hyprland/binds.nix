{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  wayland.windowManager.hyprland.settings = {
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # bindl = [",switch:Lid Switch, exec, ${pkgs.laptop_lid_switch}"];
    bindl = [
      ", switch:on:Lid Switch, exec, hyprctl dispatch dpms off"
      ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on"
    ];

    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, C, killactive,"
      "$mainMod, V, togglefloating,"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, D, togglesplit, # dwindle"

      # emoji picker
      "$mainMod, E, exec, ${getExe pkgs.rofimoji} --selector wofi --clipboarder wl-copy --action copy --typer wtype"

      # Thunderbird
      "$mainMod, T, exec, ${getExe pkgs.thunderbird}"

      # TODO: here
      # switchching focus with vim keys
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"

      "$mainMod, F, fullscreen, 1"
      "$mainMod SHIFT, F, fullscreen, 0"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # from https://github.com/Sly-Harvey/NixOS/blob/master/modules/desktop/hyprland/default.nix
      # to switch between windows in a floating workspace
      "$mainMod, Tab, cyclenext"
      "$mainMod, Tab, bringactivetotop"

      # move to the first empty workspace instantly with mainMod + CTRL + [↓]
      "$mainMod CTRL, down, workspace, empty"
    ];
  };

  #   # ----------------------------------------------------------------

  #   # show keybinds list
  #   bind = $mainMod, F1, exec, show-keybinds

  #   # keybindings
  #   bind = $mainMod, C ,exec, hyprpicker -a

  #   # window control
  #   bind = $mainMod CTRL, left, resizeactive, -80 0
  #   bind = $mainMod CTRL, right, resizeactive, 80 0
  #   bind = $mainMod CTRL, up, resizeactive, 0 -80
  #   bind = $mainMod CTRL, down, resizeactive, 0 80
  #   bind = $mainMod ALT, left, moveactive,  -80 0
  #   bind = $mainMod ALT, right, moveactive, 80 0
  #   bind = $mainMod ALT, up, moveactive, 0 -80
  #   bind = $mainMod ALT, down, moveactive, 0 80
  # '';
}
