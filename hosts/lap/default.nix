{
  inputs,
  outputs,
  ...
}:
let
  globals = rec {
    username = "marts";
    uid = 1000;
    host = "nixos-laptop";
    hostname = host;
    laptop = true;
  };
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

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit
            inputs
            outputs
            globals
            ;
        };
        useUserPackages = true;
        useGlobalPkgs = true;
        sharedModules = [
          inputs.arkenfox.hmModules.default
        ];
        users.${globals.username}.imports = [
          ./ssh-home.nix
          ./config-home.nix
          ../../modules/home-manager
          ../../home/nixos
          inputs.nix-index-database.hmModules.nix-index
          inputs.catppuccin.homeModules.catppuccin
        ];
      };
    }
  ];
}
