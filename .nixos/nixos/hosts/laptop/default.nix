{ inputs, outputs, ... }:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs outputs; };
  modules = [
    ../../modules/nixos/config-laptop.nix
    ./hardware-configuration.nix
    ./hardware-configuration-add.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = { inherit inputs outputs; };
        useUserPackages = true;
        useGlobalPkgs = true;
        users = {
          "marts" = import ../../modules/home-manager/home_laptop.nix;
        };
      };
    }
  ];
}

