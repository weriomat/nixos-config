{
  inputs,
  outputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs outputs;};
  modules = [
    ../../modules/nixos/configuration.nix
    ./hardware-configuration.nix
    ./hardware-config-add.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {inherit inputs outputs;};
        useUserPackages = true;
        useGlobalPkgs = true;
        users = {"marts" = import ../../modules/home-manager/home.nix;};
      };
    }
  ];
}
