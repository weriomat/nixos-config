{ inputs, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    ./config.nix
    ./settings.nix
    ./binds.nix
    ./windowrules.nix
  ];
}
