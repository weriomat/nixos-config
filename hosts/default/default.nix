{
  inputs,
  outputs,
  ...
}:
let
  globals = import ./globals.nix { };
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit
      inputs
      outputs
      globals
      ;
  };
  modules = [
    ../../modules/nixos
    ../../system/nixos/configuration.nix

    ./hardware-configuration.nix
    ./config.nix

    # sops
    inputs.sops-nix.nixosModules.sops

    # arkenfox
    inputs.arkenfox.hmModules.default

    # catppuccin nix
    inputs.catppuccin.nixosModules.catppuccin

    # home manger config
    ./home.nix
  ];
}
