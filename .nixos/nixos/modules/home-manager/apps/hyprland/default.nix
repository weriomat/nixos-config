{ inputs, ... }: {
  imports = [ (import ./hyprland.nix) ] ++ [ (import ./config.nix) ]
    ++ [ (import ./variables.nix) ] # ++ [ (import ./polkit.nix) ]
    ++ [ inputs.hyprland.homeManagerModules.default ];
}
