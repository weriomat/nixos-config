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
    ./power.nix
    ./ssh.nix
    ./config.nix

    # sops
    inputs.sops-nix.nixosModules.sops

    # arkenfox
    inputs.arkenfox.hmModules.default

    # catppuccin nix
    inputs.catppuccin.nixosModules.catppuccin

    # nixos hardware
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    # home manager config
    ./home.nix
  ];
}
