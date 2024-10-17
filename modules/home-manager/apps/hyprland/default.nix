{inputs, ...}: {
  imports =
    [(import ./hyprland.nix)]
    ++ [(import ./config.nix)]
    ++ [(import ./variables.nix)]
    ++ [inputs.hyprland.homeManagerModules.default];
  # TODO: here
  # drag and drop for hyprland and wayland
  # https://github.com/niksingh710/ndots/blob/master/home/optional/programs/ripdrag.nix
}
